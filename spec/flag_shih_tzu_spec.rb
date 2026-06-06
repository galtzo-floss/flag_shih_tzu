# frozen_string_literal: true

require "spec_helper"

RSpec.describe FlagShihTzu do
  describe "error hierarchy" do
    it "uses StandardError for custom errors" do
      expect(described_class::IncorrectFlagColumnException).to be < StandardError
      expect(described_class::NoSuchFlagQueryModeException).to be < StandardError
      expect(described_class::NoSuchFlagException).to be < StandardError
      expect(described_class::DuplicateFlagColumnException).to be < StandardError
    end
  end

  describe "Class Methods" do
    describe "#has_flags" do
      context "with invalid configurations" do
        it "raises an exception when flag key is negative" do
          expect do
            Class.new(ActiveRecord::Base) do
              self.table_name = "spaceships"
              include FlagShihTzu

              has_flags({-1 => :error})
            end
          end.to raise_error(ArgumentError)
        end

        it "raises an exception when flag name is already used" do
          expect do
            Class.new(ActiveRecord::Base) do
              self.table_name = "spaceships_with_2_custom_flags_column"
              include FlagShihTzu

              has_flags({1 => :jeanluckpicard}, column: "bits")
              has_flags({1 => :jeanluckpicard}, column: "commanders")
            end
          end.to raise_error(ArgumentError)
        end

        it "raises an exception when desired flag name method is already defined" do
          expect do
            Class.new(ActiveRecord::Base) do
              self.table_name = "spaceships_with_2_custom_flags_column"
              include FlagShihTzu

              def jeanluckpicard
              end

              has_flags({1 => :jeanluckpicard}, column: "bits")
            end
          end.to raise_error(ArgumentError)
        end

        it "allows an existing method to be overwritten when requested" do
          klass = nil

          expect do
            klass = Class.new(ActiveRecord::Base) do
              self.table_name = "spaceships"
              include FlagShihTzu

              def warpdrive
                "custom"
              end

              has_flags({1 => :warpdrive}, allow_overwrite: true)
            end
          end.not_to output.to_stderr

          model = klass.new

          expect(model.warpdrive).to be(false)
          model.warpdrive = true
          expect(model.warpdrive).to be(true)
        end

        it "allows Ruby keywords to be used as flag names" do
          klass = Class.new(ActiveRecord::Base) do
            self.table_name = "spaceships"
            include FlagShihTzu

            has_flags({1 => :end})
          end

          model = klass.new

          expect(model.end).to be(false)
          expect(model.not_end).to be(true)

          model.end = true

          expect(model.end).to be(true)
          expect(model.not_end).to be(false)
        end

        it "raises an exception when flag name method is defined by FlagShihTzu if strict" do
          expect do
            Class.new(ActiveRecord::Base) do
              self.table_name = "spaceships_with_2_custom_flags_column"
              include FlagShihTzu

              has_flags(
                {1 => :jeanluckpicard},
                column: "bits",
                strict: true
              )
              has_flags(
                {1 => :jeanluckpicard},
                column: "bits",
                strict: true
              )
            end
          end.to raise_error(FlagShihTzu::DuplicateFlagColumnException)
        end

        it "does not raise an exception when flag name method is defined by FlagShihTzu" do
          expect do
            Class.new(ActiveRecord::Base) do
              self.table_name = "spaceships_with_2_custom_flags_column"
              include FlagShihTzu

              has_flags({1 => :jeanluckpicard}, column: "bits")
              has_flags({1 => :jeanluckpicard}, column: "bits")
            end
          end.not_to raise_error
        end

        it "raises an exception when flag name is not a symbol" do
          expect do
            Class.new(ActiveRecord::Base) do
              self.table_name = "spaceships"
              include FlagShihTzu

              has_flags({1 => "error"})
            end
          end.to raise_error(ArgumentError)
        end

        it "raises an exception when bit width above two has no encoder" do
          expect do
            Class.new(ActiveRecord::Base) do
              self.table_name = "spaceships"
              include FlagShihTzu

              has_flags({1 => :warpdrive}, bit_width: 3)
            end
          end.to raise_error(ArgumentError, /requires an encoder/)
        end

        it "raises an exception when value mode conflicts with bit width" do
          expect do
            Class.new(ActiveRecord::Base) do
              self.table_name = "spaceships"
              include FlagShihTzu

              has_flags({1 => :warpdrive}, value_mode: :tri_state, bit_width: 1)
            end
          end.to raise_error(ArgumentError, /requires bit_width 2/)
        end

        it "raises an exception when value mode is unknown" do
          expect do
            Class.new(ActiveRecord::Base) do
              self.table_name = "spaceships"
              include FlagShihTzu

              has_flags({1 => :warpdrive}, value_mode: :quantum)
            end
          end.to raise_error(ArgumentError, /unknown value_mode/)
        end
      end

      context "with custom encoders" do
        let(:always_nil_encoder) do
          Class.new do
            class << self
              def bit_width
                1
              end

              def mask(flag_key)
                1 << (flag_key - 1)
              end

              def read(_bits, _flag_mask)
                nil
              end

              def write(bits, _flag_mask, _value)
                bits
              end

              def disabled_value(_bits, _flag_mask)
                nil
              end

              def changed?(_from_bits, _to_bits, _flag_mask)
                false
              end

              def sql_value_for(_flag_mask, _enabled)
                0
              end

              def sql_operator_for(_enabled)
                "| "
              end

              def sql_operand_for(_flag_mask, _enabled)
                0
              end

              def matches?(_bits, _flag_mask, _enabled)
                false
              end
            end
          end
        end

        it "allows custom encoders to override a built-in bit width" do
          encoder = always_nil_encoder

          model = Class.new(ActiveRecord::Base) do
            self.table_name = "spaceships"
            include FlagShihTzu

            has_flags({1 => :warpdrive}, bit_width: 1, encoder: encoder)
          end

          expect(model.new.warpdrive).to be_nil
        end
      end

      context "with SQL condition methods" do
        it "defines a sql condition method for flag enabled" do
          expect(Spaceship.warpdrive_condition).to eq('("spaceships"."flags" & 1 = 1)')
          expect(Spaceship.shields_condition).to eq('("spaceships"."flags" & 2 = 2)')
          expect(Spaceship.electrolytes_condition).to eq('("spaceships"."flags" & 4 = 4)')
        end

        it "defines a sql condition method for flag enabled with missing flags" do
          expect(SpaceshipWithMissingFlags.warpdrive_condition).to eq('("spaceships"."flags" & 1 = 1)')
          expect(SpaceshipWithMissingFlags.electrolytes_condition).to eq('("spaceships"."flags" & 4 = 4)')
        end

        it "accepts a table alias option for sql condition method" do
          expect(Spaceship.warpdrive_condition(table_alias: "old_spaceships"))
            .to eq('("old_spaceships"."flags" & 1 = 1)')
        end

        it "defines a sql condition method for flag enabled with 2 columns" do
          expect(SpaceshipWith2CustomFlagsColumn.warpdrive_condition)
            .to eq('("spaceships_with_2_custom_flags_column"."bits" & 1 = 1)')
          expect(SpaceshipWith2CustomFlagsColumn.hyperspace_condition)
            .to eq('("spaceships_with_2_custom_flags_column"."bits" & 2 = 2)')
          expect(SpaceshipWith2CustomFlagsColumn.jeanlucpicard_condition)
            .to eq('("spaceships_with_2_custom_flags_column"."commanders" & 1 = 1)')
          expect(SpaceshipWith2CustomFlagsColumn.dajanatroj_condition)
            .to eq('("spaceships_with_2_custom_flags_column"."commanders" & 2 = 2)')
        end

        it "defines a sql condition method for flag not enabled" do
          expect(Spaceship.not_warpdrive_condition).to eq('("spaceships"."flags" & 1 = 0)')
          expect(Spaceship.not_shields_condition).to eq('("spaceships"."flags" & 2 = 0)')
          expect(Spaceship.not_electrolytes_condition).to eq('("spaceships"."flags" & 4 = 0)')
        end

        it "defines a sql condition method for flag not enabled with missing flags" do
          expect(SpaceshipWithMissingFlags.not_warpdrive_condition)
            .to eq('("spaceships"."flags" & 1 = 0)')
          expect(SpaceshipWithMissingFlags.not_electrolytes_condition)
            .to eq('("spaceships"."flags" & 4 = 0)')
        end

        it "accepts a table alias option for not sql condition method" do
          expect(Spaceship.not_warpdrive_condition(table_alias: "old_spaceships"))
            .to eq('("old_spaceships"."flags" & 1 = 0)')
        end

        it "generates sql condition for flag with custom table name and default query mode" do
          expect(Spaceship.send(
            :sql_condition_for_flag,
            :warpdrive,
            "flags",
            true,
            "custom_spaceships"
          ))
            .to eq('("custom_spaceships"."flags" & 1 = 1)')
        end

        it "generates sql condition for flag with in_list query mode" do
          expect(SpaceshipWithInListQueryMode.send(
            :sql_condition_for_flag,
            :warpdrive,
            "flags",
            true,
            "spaceships"
          ))
            .to eq('("spaceships"."flags" in (1,3))')
        end

        it "generates negative sql condition for flag with in_list query mode" do
          expect(SpaceshipWithInListQueryMode.send(
            :sql_condition_for_flag,
            :warpdrive,
            "flags",
            false,
            "spaceships"
          ))
            .to eq('("spaceships"."flags" not in (1,3))')
        end

        it "generates sql condition for flag with bit_operator query mode" do
          expect(SpaceshipWithBitOperatorQueryMode.send(
            :sql_condition_for_flag,
            :warpdrive,
            "flags",
            true,
            "spaceships"
          ))
            .to eq('("spaceships"."flags" & 1 = 1)')
        end

        it "generates negative sql condition for flag with bit_operator query mode" do
          expect(SpaceshipWithBitOperatorQueryMode.send(
            :sql_condition_for_flag,
            :warpdrive,
            "flags",
            false,
            "spaceships"
          ))
            .to eq('("spaceships"."flags" & 1 = 0)')
        end

        it "raises when configured with an unknown query mode" do
          model = Class.new(ActiveRecord::Base) do
            self.table_name = "spaceships"
            include FlagShihTzu

            has_flags(1 => :warpdrive, 2 => :shields, :flag_query_mode => :unknown)
          end

          expect { model.warpdrive_condition }.to raise_error(FlagShihTzu::NoSuchFlagQueryModeException)
        end

        it "allows the global default query mode to be overridden" do
          described_class.default_flag_query_mode = :in_list
          model = Class.new(ActiveRecord::Base) do
            self.table_name = "spaceships"
            include FlagShihTzu

            has_flags(1 => :warpdrive, 2 => :shields)
          end

          expect(model.warpdrive_condition).to eq('("spaceships"."flags" in (1,3))')
        end

        it "generates sql_in_for_flag" do
          expect(Spaceship.send(:sql_in_for_flag, :warpdrive, "flags")).to eq([1, 3, 5, 7])
        end

        it "generates sql_set_for_flag" do
          expect(Spaceship.send(:sql_set_for_flag, :warpdrive, "flags"))
            .to eq('"flags" = "spaceships"."flags" | 1')
        end

        it "quotes generated flag SQL without checking out a connection" do
          expect(Spaceship).not_to receive(:connection)

          expect(Spaceship.warpdrive_condition).to eq('("spaceships"."flags" & 1 = 1)')
          expect(Spaceship.send(:sql_set_for_flag, :warpdrive, "flags"))
            .to eq('"flags" = "spaceships"."flags" | 1')
        end

        it "falls back to conservative identifier quoting when the adapter class is unavailable" do
          allow(Spaceship).to receive(:flag_connection_adapter_name).and_return("missing_adapter")

          expect(Spaceship.send(:flag_full_column_name, "spaceships", 'fl"ags'))
            .to eq('"spaceships"."fl""ags"')
          expect(Spaceship.send(:flag_full_column_name_for_assignment, "spaceships", "flags"))
            .to eq('"spaceships"."flags"')
        end

        it "falls back to conservative identifier quoting when adapter class methods are unavailable" do
          adapter = Class.new
          allow(Spaceship).to receive(:flag_connection_adapter_class).and_return(adapter)

          expect(Spaceship.send(:flag_full_column_name, "spaceships", 'fl"ags'))
            .to eq('"spaceships"."fl""ags"')
        end

        it "uses column-only assignments for jdbcsqlite3" do
          allow(Spaceship).to receive(:flag_connection_adapter_name).and_return("jdbcsqlite3")

          expect(Spaceship.send(:flag_full_column_name_for_assignment, "spaceships", "flags"))
            .to eq('"flags"')
        end

        it "defines a sql condition method for flag enabled with 2 columns not enabled" do
          expect(SpaceshipWith2CustomFlagsColumn.not_warpdrive_condition)
            .to eq('("spaceships_with_2_custom_flags_column"."bits" & 1 = 0)')
          expect(SpaceshipWith2CustomFlagsColumn.not_hyperspace_condition)
            .to eq('("spaceships_with_2_custom_flags_column"."bits" & 2 = 0)')
          expect(SpaceshipWith2CustomFlagsColumn.not_jeanlucpicard_condition)
            .to eq('("spaceships_with_2_custom_flags_column"."commanders" & 1 = 0)')
          expect(SpaceshipWith2CustomFlagsColumn.not_dajanatroj_condition)
            .to eq('("spaceships_with_2_custom_flags_column"."commanders" & 2 = 0)')
        end

        it "defines a sql condition method for flag enabled using bit operators" do
          expect(SpaceshipWithBitOperatorQueryMode.warpdrive_condition)
            .to eq('("spaceships"."flags" & 1 = 1)')
          expect(SpaceshipWithBitOperatorQueryMode.shields_condition)
            .to eq('("spaceships"."flags" & 2 = 2)')
        end

        it "defines a sql condition method for flag not enabled using bit operators" do
          expect(SpaceshipWithBitOperatorQueryMode.not_warpdrive_condition)
            .to eq('("spaceships"."flags" & 1 = 0)')
          expect(SpaceshipWithBitOperatorQueryMode.not_shields_condition)
            .to eq('("spaceships"."flags" & 2 = 0)')
        end
      end

      context "with named scopes" do
        def assert_where_value(expected, scope)
          ast = scope.where_clause.ast
          actual = if ast.respond_to?(:expr)
            ast.expr
          elsif ast.respond_to?(:children) && ast.children.one? && ast.children.first.respond_to?(:expr)
            ast.children.first.expr
          else
            ast
          end
          expect(actual).to eq(expected)
        end

        it "defines a named scope for flag enabled" do
          assert_where_value('("spaceships"."flags" & 1 = 1)', Spaceship.warpdrive)
          assert_where_value('("spaceships"."flags" & 2 = 2)', Spaceship.shields)
          assert_where_value('("spaceships"."flags" & 4 = 4)', Spaceship.electrolytes)
        end

        it "defines a named scope for flag not enabled" do
          assert_where_value('("spaceships"."flags" & 1 = 0)', Spaceship.not_warpdrive)
          assert_where_value('("spaceships"."flags" & 2 = 0)', Spaceship.not_shields)
          assert_where_value('("spaceships"."flags" & 4 = 0)', Spaceship.not_electrolytes)
        end

        it "defines a dynamic column value helpers for flags" do
          expect(Spaceship.flag_values_for(:warpdrive)).to eq([1, 3, 5, 7])
          expect(Spaceship.flag_values_for(:warpdrive, :shields)).to eq([3, 7])
        end

        it "defines a named scope for flag enabled with 2 columns" do
          assert_where_value(
            '("spaceships_with_2_custom_flags_column"."bits" & 1 = 1)',
            SpaceshipWith2CustomFlagsColumn.warpdrive
          )
          assert_where_value(
            '("spaceships_with_2_custom_flags_column"."bits" & 2 = 2)',
            SpaceshipWith2CustomFlagsColumn.hyperspace
          )
          assert_where_value(
            '("spaceships_with_2_custom_flags_column"."commanders" & 1 = 1)',
            SpaceshipWith2CustomFlagsColumn.jeanlucpicard
          )
          assert_where_value(
            '("spaceships_with_2_custom_flags_column"."commanders" & 2 = 2)',
            SpaceshipWith2CustomFlagsColumn.dajanatroj
          )
        end

        it "defines a named scope for flag not enabled with 2 columns" do
          assert_where_value(
            '("spaceships_with_2_custom_flags_column"."bits" & 1 = 0)',
            SpaceshipWith2CustomFlagsColumn.not_warpdrive
          )
          assert_where_value(
            '("spaceships_with_2_custom_flags_column"."bits" & 2 = 0)',
            SpaceshipWith2CustomFlagsColumn.not_hyperspace
          )
          assert_where_value(
            '("spaceships_with_2_custom_flags_column"."commanders" & 1 = 0)',
            SpaceshipWith2CustomFlagsColumn.not_jeanlucpicard
          )
          assert_where_value(
            '("spaceships_with_2_custom_flags_column"."commanders" & 2 = 0)',
            SpaceshipWith2CustomFlagsColumn.not_dajanatroj
          )
        end

        it "defines a named scope for flag enabled using bit operators" do
          assert_where_value(
            '("spaceships"."flags" & 1 = 1)',
            SpaceshipWithBitOperatorQueryMode.warpdrive
          )
          assert_where_value(
            '("spaceships"."flags" & 2 = 2)',
            SpaceshipWithBitOperatorQueryMode.shields
          )
        end

        it "defines a named scope for flag not enabled using bit operators" do
          assert_where_value(
            '("spaceships"."flags" & 1 = 0)',
            SpaceshipWithBitOperatorQueryMode.not_warpdrive
          )
          assert_where_value(
            '("spaceships"."flags" & 2 = 0)',
            SpaceshipWithBitOperatorQueryMode.not_shields
          )
        end

        it "works with raw SQL" do
          spaceship = Spaceship.new
          spaceship.enable_flag(:shields)
          spaceship.enable_flag(:electrolytes)
          spaceship.save!

          expect(spaceship.warpdrive).to be(false)
          expect(spaceship.shields).to be(true)
          expect(spaceship.electrolytes).to be(true)

          if ActiveRecord::VERSION::MAJOR <= 3
            Spaceship.update_all(
              Spaceship.set_flag_sql(:warpdrive, true),
              ["id=?", spaceship.id]
            )
          else
            Spaceship.where("id=?", spaceship.id).update_all(
              Spaceship.set_flag_sql(:warpdrive, true)
            )
          end

          spaceship.reload

          expect(spaceship.warpdrive).to be(true)
          expect(spaceship.shields).to be(true)
          expect(spaceship.electrolytes).to be(true)

          spaceship2 = Spaceship.new
          spaceship2.enable_flag(:warpdrive)
          spaceship2.enable_flag(:shields)
          spaceship2.enable_flag(:electrolytes)
          spaceship2.save!

          expect(spaceship2.warpdrive).to be(true)
          expect(spaceship2.shields).to be(true)
          expect(spaceship2.electrolytes).to be(true)

          if ActiveRecord::VERSION::MAJOR <= 3
            Spaceship.update_all(
              Spaceship.set_flag_sql(:shields, false),
              ["id=?", spaceship2.id]
            )
          else
            Spaceship.where("id=?", spaceship2.id).update_all(
              Spaceship.set_flag_sql(:shields, false)
            )
          end

          spaceship2.reload

          expect(spaceship2.warpdrive).to be(true)
          expect(spaceship2.shields).to be(false)
          expect(spaceship2.electrolytes).to be(true)
        end

        it "returns the correct number of items from a named scope" do
          Spaceship.create!(warpdrive: true, shields: true)
          Spaceship.create!(warpdrive: true)
          Spaceship.create!(shields: true)

          expect(Spaceship.not_warpdrive.count).to eq(1)
          expect(Spaceship.warpdrive.count).to eq(2)
          expect(Spaceship.not_shields.count).to eq(1)
          expect(Spaceship.shields.count).to eq(2)
          expect(Spaceship.warpdrive.shields.count).to eq(1)
          expect(Spaceship.not_warpdrive.not_shields).to be_empty
        end

        it "keeps remaining flag scopes correct after another flag is removed from the model" do
          Spaceship.create!(warpdrive: true, shields: true)
          model = Class.new(ActiveRecord::Base) do
            self.table_name = "spaceships"
            include FlagShihTzu

            has_flags 1 => :warpdrive
          end

          expect(model.first.flags).to eq(3)
          expect(model.first.warpdrive?).to be(true)
          expect(model.warpdrive.count).to eq(1)
        end

        it "documents the legacy in_list behavior when another flag is removed from the model" do
          Spaceship.create!(warpdrive: true, shields: true)
          model = Class.new(ActiveRecord::Base) do
            self.table_name = "spaceships"
            include FlagShihTzu

            has_flags 1 => :warpdrive, :flag_query_mode => :in_list
          end

          expect(model.first.flags).to eq(3)
          expect(model.first.warpdrive?).to be(true)
          expect(model.warpdrive).to be_empty
        end

        it "returns the correct condition with chained flags" do
          expect(Spaceship.chained_flags_condition("flags", :warpdrive, :shields))
            .to eq('("spaceships"."flags" & 1 = 1 AND "spaceships"."flags" & 2 = 2)')
          expect(Spaceship.chained_flags_condition("flags", :warpdrive, :shields, :electrolytes))
            .to eq('("spaceships"."flags" & 1 = 1 AND "spaceships"."flags" & 2 = 2 AND "spaceships"."flags" & 4 = 4)')
          expect(Spaceship.chained_flags_condition("flags", :not_warpdrive, :shields))
            .to eq('("spaceships"."flags" & 1 = 0 AND "spaceships"."flags" & 2 = 2)')
        end

        it "uses value-list SQL for chained flags in in_list mode" do
          expect(SpaceshipWithInListQueryMode.chained_flags_condition("flags", :warpdrive, :shields))
            .to eq('("spaceships"."flags" in (3))')
          expect(SpaceshipWithInListQueryMode.chained_flags_condition("flags", :not_warpdrive, :shields))
            .to eq('("spaceships"."flags" in (2))')
        end

        it "returns the correct number of items with chained flags" do
          Spaceship.create!(warpdrive: true, shields: true)
          Spaceship.create!(warpdrive: true)
          Spaceship.create!(shields: true)
          Spaceship.create!

          expect(Spaceship.chained_flags_with("flags", :warpdrive).count).to eq(2)
          expect(Spaceship.chained_flags_with("flags", :warpdrive, :shields).count).to eq(1)
          expect(Spaceship.chained_flags_with("flags", :warpdrive, :not_shields).count).to eq(1)
          expect(Spaceship.chained_flags_with("flags", :not_warpdrive, :shields, :electrolytes)).to be_empty
          expect(Spaceship.chained_flags_with("flags", :not_warpdrive, :shields, :not_electrolytes).count).to eq(1)
          expect(Spaceship.chained_flags_with("flags", :not_warpdrive, :not_shields, :not_electrolytes).count).to eq(1)
        end

        it "does not define named scopes if not wanted" do
          expect(SpaceshipWithoutNamedScopes.respond_to?(:warpdrive)).to be(false)
          expect(SpaceshipWithoutNamedScopesOldStyle.respond_to?(:warpdrive)).to be(false)
        end
      end

      context "with custom flags column" do
        it "works with a custom flags column" do
          spaceship = SpaceshipWithCustomFlagsColumn.new
          spaceship.enable_flag(:warpdrive)
          spaceship.enable_flag(:hyperspace)
          spaceship.save!
          spaceship.reload

          expect(spaceship.flags("bits")).to eq(3)
          expect(SpaceshipWithCustomFlagsColumn.warpdrive_condition)
            .to eq('("spaceships_with_custom_flags_column"."bits" & 1 = 1)')
          expect(SpaceshipWithCustomFlagsColumn.not_warpdrive_condition)
            .to eq('("spaceships_with_custom_flags_column"."bits" & 1 = 0)')
          expect(SpaceshipWithCustomFlagsColumn.hyperspace_condition)
            .to eq('("spaceships_with_custom_flags_column"."bits" & 2 = 2)')
          expect(SpaceshipWithCustomFlagsColumn.not_hyperspace_condition)
            .to eq('("spaceships_with_custom_flags_column"."bits" & 2 = 0)')

          def assert_where_value(expected, scope)
            ast = scope.where_clause.ast
            actual = if ast.respond_to?(:expr)
              ast.expr
            elsif ast.respond_to?(:children) && ast.children.one? && ast.children.first.respond_to?(:expr)
              ast.children.first.expr
            else
              ast
            end
            expect(actual).to eq(expected)
          end

          assert_where_value(
            '("spaceships_with_custom_flags_column"."bits" & 1 = 1)',
            SpaceshipWithCustomFlagsColumn.warpdrive
          )
          assert_where_value(
            '("spaceships_with_custom_flags_column"."bits" & 1 = 0)',
            SpaceshipWithCustomFlagsColumn.not_warpdrive
          )
          assert_where_value(
            '("spaceships_with_custom_flags_column"."bits" & 2 = 2)',
            SpaceshipWithCustomFlagsColumn.hyperspace
          )
          assert_where_value(
            '("spaceships_with_custom_flags_column"."bits" & 2 = 0)',
            SpaceshipWithCustomFlagsColumn.not_hyperspace
          )
        end

        it "works with a custom flags column name as symbol" do
          spaceship = SpaceshipWithColumnNameAsSymbol.new
          spaceship.enable_flag(:warpdrive)
          spaceship.save!
          spaceship.reload

          expect(spaceship.flags("bits")).to eq(1)
        end
      end

      context "with missing tables and columns" do
        it "does not error out when table is not present" do
          expect do
            Planet.class_eval do
              include FlagShihTzu

              has_flags(1 => :habitable)
            end
          end.not_to raise_error
        end

        it "does not error out when column is not present" do
          expect do
            Planet.class_eval do
              # Now it has a table that exists, but the column does not.
              self.table_name = "spaceships"
              include FlagShihTzu

              has_flags(
                {1 => :warpdrive, 2 => :hyperspace},
                column: :i_do_not_exist,
                check_for_column: true
              )
            end
          end.not_to raise_error
        end
      end
    end

    describe "#flag_columns" do
      it "tracks columns used by FlagShihTzu" do
        expect(Spaceship.flag_columns).to eq(["flags"])
        expect(SpaceshipWith2CustomFlagsColumn.flag_columns).to eq(["bits", "commanders"])
        expect(SpaceshipWith3CustomFlagsColumn.flag_columns).to eq(["engines", "weapons", "hal3000"])

        if ActiveRecord::VERSION::MAJOR >= 3
          expect(SpaceshipWithValidationsAnd3CustomFlagsColumn.flag_columns)
            .to eq(["engines", "weapons", "hal3000"])
          expect(SpaceshipWithSymbolAndStringFlagColumns.flag_columns)
            .to eq(["peace", "love", "happiness"])
        end
      end
    end
  end
end
