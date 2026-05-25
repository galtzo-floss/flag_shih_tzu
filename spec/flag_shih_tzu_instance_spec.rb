# frozen_string_literal: true

require "spec_helper"

RSpec.describe "FlagShihTzu Instance Methods" do
  let(:spaceship) { Spaceship.new }
  let(:big_spaceship) { SpaceshipWith2CustomFlagsColumn.new }
  let(:small_spaceship) { SpaceshipWithCustomFlagsColumn.new }

  describe "flag operations" do
    it "enables a flag" do
      spaceship.enable_flag(:warpdrive)
      expect(spaceship.flag_enabled?(:warpdrive)).to eq(true)
    end

    it "enables a flag with 2 columns" do
      big_spaceship.enable_flag(:warpdrive)
      expect(big_spaceship.flag_enabled?(:warpdrive)).to eq(true)
      big_spaceship.enable_flag(:jeanlucpicard)
      expect(big_spaceship.flag_enabled?(:jeanlucpicard)).to eq(true)
    end

    it "disables a flag" do
      spaceship.enable_flag(:warpdrive)
      expect(spaceship.flag_enabled?(:warpdrive)).to eq(true)

      spaceship.disable_flag(:warpdrive)
      expect(spaceship.flag_disabled?(:warpdrive)).to eq(true)
    end

    it "disables a flag with 2 columns" do
      big_spaceship.enable_flag(:warpdrive)
      expect(big_spaceship.flag_enabled?(:warpdrive)).to eq(true)
      big_spaceship.enable_flag(:jeanlucpicard)
      expect(big_spaceship.flag_enabled?(:jeanlucpicard)).to eq(true)

      big_spaceship.disable_flag(:warpdrive)
      expect(big_spaceship.flag_disabled?(:warpdrive)).to eq(true)
      big_spaceship.disable_flag(:jeanlucpicard)
      expect(big_spaceship.flag_disabled?(:jeanlucpicard)).to eq(true)
    end

    it "stores the flags correctly" do
      spaceship.enable_flag(:warpdrive)
      spaceship.disable_flag(:shields)
      spaceship.enable_flag(:electrolytes)

      spaceship.save!
      spaceship.reload

      expect(spaceship.flags).to eq(5)
      expect(spaceship.flag_enabled?(:warpdrive)).to eq(true)
      expect(spaceship.flag_enabled?(:shields)).to eq(false)
      expect(spaceship.flag_enabled?(:electrolytes)).to eq(true)
    end

    it "stores the flags correctly with 2 columns" do
      big_spaceship.enable_flag(:warpdrive)
      big_spaceship.disable_flag(:hyperspace)
      big_spaceship.enable_flag(:dajanatroj)

      big_spaceship.save!
      big_spaceship.reload

      expect(big_spaceship.flags("bits")).to eq(1)
      expect(big_spaceship.flags("commanders")).to eq(2)

      expect(big_spaceship.flag_enabled?(:warpdrive)).to eq(true)
      expect(big_spaceship.flag_enabled?(:hyperspace)).to eq(false)
      expect(big_spaceship.flag_enabled?(:dajanatroj)).to eq(true)
    end

    it "leaves the flag enabled when enable_flag is called twice" do
      2.times do
        spaceship.enable_flag(:warpdrive)
        expect(spaceship.flag_enabled?(:warpdrive)).to eq(true)
      end
    end

    it "leaves the flag disabled when disable_flag is called twice" do
      2.times do
        spaceship.disable_flag(:warpdrive)
        expect(spaceship.flag_enabled?(:warpdrive)).to eq(false)
      end
    end
  end

  describe "attribute reader methods" do
    it "defines an attribute reader method" do
      expect(spaceship.warpdrive).to eq(false)
    end

    it "defines a negative attribute reader method" do
      expect(spaceship.not_warpdrive).to eq(true)
    end

    it "defines an attribute reader predicate method" do
      expect(spaceship.warpdrive?).to eq(false)
    end

    it "defines a negative attribute reader predicate method" do
      expect(spaceship.not_warpdrive?).to eq(true)
    end
  end

  describe "all_flags methods" do
    it "defines an all_flags reader method with arity 1" do
      expect(spaceship.all_flags("flags")).to match_array_unordered([:electrolytes, :warpdrive, :shields])
    end

    it "defines an all_flags reader method with arity 0" do
      expect(spaceship.all_flags).to match_array_unordered([:electrolytes, :warpdrive, :shields])
    end

    it "defines a customized all_flags reader method" do
      expect(small_spaceship.all_bits).to match_array_unordered([:hyperspace, :warpdrive])
    end

    it "defines a customized all_flags reader method with 2 columns" do
      expect(big_spaceship.all_bits).to match_array_unordered([:hyperspace, :warpdrive])
      expect(big_spaceship.all_commanders).to match_array_unordered([:dajanatroj, :jeanlucpicard])
    end
  end

  describe "selected_flags methods" do
    it "defines a selected_flags reader method with arity 1" do
      expect(spaceship.selected_flags("flags")).to match_array_unordered([])

      spaceship.warpdrive = true
      expect(spaceship.selected_flags("flags")).to match_array_unordered([:warpdrive])

      spaceship.electrolytes = true
      expect(spaceship.selected_flags("flags")).to match_array_unordered([:electrolytes, :warpdrive])

      spaceship.warpdrive = false
      spaceship.electrolytes = false
      expect(spaceship.selected_flags("flags")).to match_array_unordered([])
    end

    it "defines a selected_flags reader method with arity 0" do
      expect(spaceship.selected_flags).to match_array_unordered([])

      spaceship.warpdrive = true
      expect(spaceship.selected_flags).to match_array_unordered([:warpdrive])

      spaceship.electrolytes = true
      expect(spaceship.selected_flags).to match_array_unordered([:electrolytes, :warpdrive])

      spaceship.warpdrive = false
      spaceship.electrolytes = false
      expect(spaceship.selected_flags).to match_array_unordered([])
    end

    it "defines a customized selected_flags reader method" do
      expect(small_spaceship.selected_bits).to match_array_unordered([])

      small_spaceship.warpdrive = true
      expect(small_spaceship.selected_bits).to match_array_unordered([:warpdrive])

      small_spaceship.hyperspace = true
      expect(small_spaceship.selected_bits).to match_array_unordered([:hyperspace, :warpdrive])

      small_spaceship.warpdrive = false
      small_spaceship.hyperspace = false
      expect(small_spaceship.selected_bits).to match_array_unordered([])
    end

    it "defines a customized selected_flags reader method with 2 columns" do
      expect(big_spaceship.selected_bits).to match_array_unordered([])
      expect(big_spaceship.selected_commanders).to match_array_unordered([])

      big_spaceship.warpdrive = true
      big_spaceship.jeanlucpicard = true
      expect(big_spaceship.selected_bits).to match_array_unordered([:warpdrive])
      expect(big_spaceship.selected_commanders).to match_array_unordered([:jeanlucpicard])

      big_spaceship.hyperspace = true
      big_spaceship.dajanatroj = true
      expect(big_spaceship.selected_bits).to match_array_unordered([:hyperspace, :warpdrive])
      expect(big_spaceship.selected_commanders).to match_array_unordered([:dajanatroj, :jeanlucpicard])

      big_spaceship.warpdrive = false
      big_spaceship.hyperspace = false
      big_spaceship.jeanlucpicard = false
      big_spaceship.dajanatroj = false
      expect(big_spaceship.selected_bits).to match_array_unordered([])
      expect(big_spaceship.selected_commanders).to match_array_unordered([])
    end
  end

  describe "select_all_flags methods" do
    it "defines a select_all_flags method with arity 1" do
      spaceship.select_all_flags("flags")
      expect(spaceship.warpdrive).to eq(true)
      expect(spaceship.shields).to eq(true)
      expect(spaceship.electrolytes).to eq(true)
    end

    it "defines a select_all_flags method with arity 0" do
      spaceship.select_all_flags
      expect(spaceship.warpdrive).to eq(true)
      expect(spaceship.shields).to eq(true)
      expect(spaceship.electrolytes).to eq(true)
    end

    it "defines a customized select_all_flags method" do
      small_spaceship.select_all_bits
      expect(small_spaceship.warpdrive).to eq(true)
      expect(small_spaceship.hyperspace).to eq(true)
    end

    it "defines a customized select_all_flags method with 2 columns" do
      big_spaceship.select_all_bits
      big_spaceship.select_all_commanders
      expect(big_spaceship.warpdrive).to eq(true)
      expect(big_spaceship.hyperspace).to eq(true)
      expect(big_spaceship.jeanlucpicard).to eq(true)
      expect(big_spaceship.dajanatroj).to eq(true)
    end
  end

  describe "unselect_all_flags methods" do
    it "defines an unselect_all_flags method with arity 1" do
      spaceship.warpdrive = true
      spaceship.shields = true
      spaceship.electrolytes = true

      spaceship.unselect_all_flags("flags")

      expect(spaceship.warpdrive).to eq(false)
      expect(spaceship.shields).to eq(false)
      expect(spaceship.electrolytes).to eq(false)
    end

    it "defines an unselect_all_flags method with arity 0" do
      spaceship.warpdrive = true
      spaceship.shields = true
      spaceship.electrolytes = true

      spaceship.unselect_all_flags

      expect(spaceship.warpdrive).to eq(false)
      expect(spaceship.shields).to eq(false)
      expect(spaceship.electrolytes).to eq(false)
    end

    it "defines a customized unselect_all_flags method" do
      small_spaceship.warpdrive = true
      small_spaceship.hyperspace = true

      small_spaceship.unselect_all_bits

      expect(small_spaceship.warpdrive).to eq(false)
      expect(small_spaceship.hyperspace).to eq(false)
    end

    it "defines a customized unselect_all_flags method with 2 columns" do
      big_spaceship.warpdrive = true
      big_spaceship.hyperspace = true
      big_spaceship.jeanlucpicard = true
      big_spaceship.dajanatroj = true

      big_spaceship.unselect_all_bits
      big_spaceship.unselect_all_commanders

      expect(big_spaceship.warpdrive).to eq(false)
      expect(big_spaceship.hyperspace).to eq(false)
      expect(big_spaceship.jeanlucpicard).to eq(false)
      expect(big_spaceship.dajanatroj).to eq(false)
    end
  end

  describe "has_flag? methods" do
    it "defines an has_flag method with arity 1" do
      expect(spaceship.has_flag?("flags")).to eq(false)

      spaceship.warpdrive = true
      expect(spaceship.has_flag?("flags")).to eq(true)

      spaceship.shields = true
      expect(spaceship.has_flag?("flags")).to eq(true)

      spaceship.electrolytes = true
      expect(spaceship.has_flag?("flags")).to eq(true)

      spaceship.unselect_all_flags("flags")
      expect(spaceship.has_flag?("flags")).to eq(false)
    end

    it "defines an has_flag method with arity 0" do
      expect(spaceship.has_flag?).to eq(false)

      spaceship.warpdrive = true
      expect(spaceship.has_flag?).to eq(true)

      spaceship.shields = true
      expect(spaceship.has_flag?).to eq(true)

      spaceship.electrolytes = true
      expect(spaceship.has_flag?).to eq(true)

      spaceship.unselect_all_flags
      expect(spaceship.has_flag?).to eq(false)
    end

    it "defines a customized has_flag method" do
      expect(small_spaceship.has_bit?).to eq(false)

      small_spaceship.warpdrive = true
      expect(small_spaceship.has_bit?).to eq(true)

      small_spaceship.hyperspace = true
      expect(small_spaceship.has_bit?).to eq(true)

      small_spaceship.unselect_all_bits
      expect(small_spaceship.has_bit?).to eq(false)
    end

    it "defines a customized has_flag method with 2 columns" do
      expect(big_spaceship.has_bit?).to eq(false)
      expect(big_spaceship.has_commander?).to eq(false)

      big_spaceship.warpdrive = true
      big_spaceship.jeanlucpicard = true
      expect(big_spaceship.has_bit?).to eq(true)
      expect(big_spaceship.has_commander?).to eq(true)

      big_spaceship.hyperspace = true
      big_spaceship.dajanatroj = true
      expect(big_spaceship.has_bit?).to eq(true)

      big_spaceship.unselect_all_bits
      big_spaceship.unselect_all_commanders
      expect(big_spaceship.has_bit?).to eq(false)
    end
  end

  describe "selected_flags writer" do
    it "defines a selected_flags writer method" do
      spaceship.selected_flags = [:warpdrive]
      expect(spaceship.warpdrive).to eq(true)
      expect(spaceship.shields).to eq(false)
      expect(spaceship.electrolytes).to eq(false)

      spaceship.selected_flags = [:warpdrive, :shields, :electrolytes]
      expect(spaceship.warpdrive).to eq(true)
      expect(spaceship.shields).to eq(true)
      expect(spaceship.electrolytes).to eq(true)

      spaceship.selected_flags = []
      expect(spaceship.warpdrive).to eq(false)
      expect(spaceship.shields).to eq(false)
      expect(spaceship.electrolytes).to eq(false)

      spaceship.selected_flags = [:warpdrive, :shields, :electrolytes]
      spaceship.selected_flags = nil
      expect(spaceship.warpdrive).to eq(false)
      expect(spaceship.shields).to eq(false)
      expect(spaceship.electrolytes).to eq(false)
    end

    it "defines a customized selected_flags writer method" do
      small_spaceship.selected_bits = [:warpdrive]
      expect(small_spaceship.warpdrive).to eq(true)
      expect(small_spaceship.hyperspace).to eq(false)

      small_spaceship.selected_bits = [:hyperspace]
      expect(small_spaceship.warpdrive).to eq(false)
      expect(small_spaceship.hyperspace).to eq(true)

      small_spaceship.selected_bits = [:hyperspace, :warpdrive]
      expect(small_spaceship.warpdrive).to eq(true)
      expect(small_spaceship.hyperspace).to eq(true)

      small_spaceship.selected_bits = []
      expect(small_spaceship.warpdrive).to eq(false)
      expect(small_spaceship.hyperspace).to eq(false)

      small_spaceship.selected_bits = nil
      expect(small_spaceship.warpdrive).to eq(false)
      expect(small_spaceship.hyperspace).to eq(false)
    end

    it "defines a customized selected_flags writer method with 2 columns" do
      big_spaceship.selected_bits = [:warpdrive]
      big_spaceship.selected_commanders = [:jeanlucpicard]
      expect(big_spaceship.warpdrive).to eq(true)
      expect(big_spaceship.hyperspace).to eq(false)
      expect(big_spaceship.jeanlucpicard).to eq(true)
      expect(big_spaceship.dajanatroj).to eq(false)

      big_spaceship.selected_bits = [:hyperspace]
      big_spaceship.selected_commanders = [:dajanatroj]
      expect(big_spaceship.warpdrive).to eq(false)
      expect(big_spaceship.hyperspace).to eq(true)
      expect(big_spaceship.jeanlucpicard).to eq(false)
      expect(big_spaceship.dajanatroj).to eq(true)

      big_spaceship.selected_bits = [:hyperspace, :warpdrive]
      big_spaceship.selected_commanders = [:dajanatroj, :jeanlucpicard]
      expect(big_spaceship.warpdrive).to eq(true)
      expect(big_spaceship.hyperspace).to eq(true)
      expect(big_spaceship.jeanlucpicard).to eq(true)
      expect(big_spaceship.dajanatroj).to eq(true)

      big_spaceship.selected_bits = []
      big_spaceship.selected_commanders = []
      expect(big_spaceship.warpdrive).to eq(false)
      expect(big_spaceship.hyperspace).to eq(false)
      expect(big_spaceship.jeanlucpicard).to eq(false)
      expect(big_spaceship.dajanatroj).to eq(false)

      big_spaceship.selected_bits = nil
      big_spaceship.selected_commanders = nil
      expect(big_spaceship.warpdrive).to eq(false)
      expect(big_spaceship.hyperspace).to eq(false)
      expect(big_spaceship.jeanlucpicard).to eq(false)
      expect(big_spaceship.dajanatroj).to eq(false)
    end
  end

  describe "attribute writer methods" do
    it "defines an attribute writer method" do
      spaceship.warpdrive = true
      expect(spaceship.warpdrive).to eq(true)
    end

    it "defines a negative attribute writer method" do
      spaceship.not_warpdrive = false
      expect(spaceship.warpdrive).to eq(true)
    end

    it "respects true values like ActiveRecord" do
      [true, 1, "1", "t", "T", "true", "TRUE"].each do |true_value|
        spaceship.warpdrive = true_value
        expect(spaceship.warpdrive).to eq(true)
      end

      [false, 0, "0", "f", "F", "false", "FALSE"].each do |false_value|
        spaceship.warpdrive = false_value
        expect(spaceship.warpdrive).to eq(false)
      end
    end
  end

  describe "dirty tracking" do
    it "defines dirty suffix changed?" do
      expect(spaceship.warpdrive_changed?).to eq(false)
      expect(spaceship.shields_changed?).to eq(false)

      spaceship.enable_flag(:warpdrive)
      expect(spaceship.warpdrive_changed?).to eq(true)
      expect(spaceship.shields_changed?).to eq(false)

      spaceship.enable_flag(:shields)
      expect(spaceship.warpdrive_changed?).to eq(true)
      expect(spaceship.shields_changed?).to eq(true)

      spaceship.disable_flag(:warpdrive)
      expect(spaceship.warpdrive_changed?).to eq(false)
      expect(spaceship.shields_changed?).to eq(true)

      spaceship.disable_flag(:shields)
      expect(spaceship.warpdrive_changed?).to eq(false)
      expect(spaceship.shields_changed?).to eq(false)
    end
  end

  describe "column checking" do
    it "ignores has_flags call if column does not exist yet with default check_for_column" do
      expect do
        Class.new(ActiveRecord::Base) do
          self.table_name = "spaceships_without_flags_column"
          include FlagShihTzu

          has_flags 1 => :warpdrive,
                    2 => :shields,
                    3 => :electrolytes
        end
      end.not_to raise_error

      klass = Class.new(ActiveRecord::Base) do
        self.table_name = "spaceships_without_flags_column"
        include FlagShihTzu

        has_flags 1 => :warpdrive,
                  2 => :shields,
                  3 => :electrolytes
      end

      expect(klass.method_defined?(:warpdrive)).to eq(false)
    end

    it "ignores has_flags call if column is not integer with default check_for_column" do
      expect do
        Class.new(ActiveRecord::Base) do
          self.table_name = "spaceships_with_non_integer_column"
          include FlagShihTzu

          has_flags 1 => :warpdrive,
                    2 => :shields,
                    3 => :electrolytes
        end
      end.to raise_error(FlagShihTzu::IncorrectFlagColumnException)
    end

    it "ignores has_flags call if column does not exist yet and check_for_column is true" do
      klass = Class.new(ActiveRecord::Base) do
        self.table_name = "spaceships_without_flags_column"
        include FlagShihTzu

        has_flags 1 => :warpdrive,
                  2 => :shields,
                  3 => :electrolytes,
                  check_for_column: true
      end

      expect(klass.send(:check_flag_column, "flags")).to eq(false)
      expect(klass.method_defined?(:warpdrive)).to eq(false)
    end

    it "ignores has_flags call if column is not integer and check_for_column is true" do
      expect do
        Class.new(ActiveRecord::Base) do
          self.table_name = "spaceships_with_non_integer_column"
          include FlagShihTzu

          has_flags 1 => :warpdrive,
                    2 => :shields,
                    3 => :electrolytes,
                    check_for_column: true
        end
      end.to raise_error(FlagShihTzu::IncorrectFlagColumnException)
    end

    it "ignores has_flags call if column does not exist yet and check_for_column is false" do
      klass = Class.new(ActiveRecord::Base) do
        self.table_name = "spaceships_without_flags_column"
        include FlagShihTzu

        has_flags 1 => :warpdrive,
                  2 => :shields,
                  3 => :electrolytes,
                  check_for_column: false
      end

      expect(klass.method_defined?(:warpdrive)).to eq(true)
    end

    it "ignores has_flags call if column is not integer and check_for_column is false" do
      klass = Class.new(ActiveRecord::Base) do
        self.table_name = "spaceships_with_non_integer_column"
        include FlagShihTzu

        has_flags 1 => :warpdrive,
                  2 => :shields,
                  3 => :electrolytes,
                  check_for_column: false
      end

      expect(klass.method_defined?(:warpdrive)).to eq(true)
    end

    if ActiveRecord::VERSION::STRING >= "4.1."
      it "ignores database missing errors" do
        klass = Class.new(ActiveRecord::Base) do
          def self.connection
            raise ActiveRecord::NoDatabaseError.new("Unknown database")
          end

          self.table_name = "spaceships"
          include FlagShihTzu

          has_flags 1 => :warpdrive,
                    2 => :shields,
                    3 => :electrolytes
        end

        expect(klass.method_defined?(:warpdrive)).to eq(true)
      end
    end

    it "doesn't establish a connection if check_for_column is false" do
      connection_established = false

      klass = Class.new(ActiveRecord::Base) do
        define_singleton_method(:connection_established?) { connection_established }
        define_singleton_method(:connection) do
          connection_established = true
          super()
        end

        self.table_name = "spaceships"
        include FlagShihTzu

        has_flags({
          1 => :warpdrive,
          2 => :shields,
          3 => :electrolytes
        }, check_for_column: false)
      end

      expect(klass.method_defined?(:warpdrive)).to eq(true)
      # Note: This test might not work exactly as in test-unit due to how connection pooling works
    end
  end

  describe "column guessing" do
    it "guesses column for default column" do
      expect(spaceship.class.determine_flag_colmn_for(:warpdrive)).to eq("flags")
    end

    it "raises exception for unknown flag" do
      expect do
        spaceship.class.determine_flag_colmn_for(:xxx)
      end.to raise_error(FlagShihTzu::NoSuchFlagException)
    end

    it "guesses column for 2 columns" do
      expect(big_spaceship.class.determine_flag_colmn_for(:jeanlucpicard)).to eq("commanders")
      expect(big_spaceship.class.determine_flag_colmn_for(:warpdrive)).to eq("bits")
    end
  end

  describe "#update_flag!" do
    it "updates flag without updating instance" do
      my_spaceship = SpaceshipWith2CustomFlagsColumn.new
      my_spaceship.enable_flag(:jeanlucpicard)
      my_spaceship.disable_flag(:warpdrive)
      my_spaceship.save

      expect(my_spaceship.jeanlucpicard).to eq(true)
      expect(my_spaceship.warpdrive).to eq(false)

      expect(my_spaceship.update_flag!(:jeanlucpicard, false)).to eq(true)
      expect(my_spaceship.update_flag!(:warpdrive, true)).to eq(true)

      # Not updating the instance here,
      #   so it won't reflect the result of the SQL update until after reloaded
      expect(my_spaceship.jeanlucpicard).to eq(true)
      expect(my_spaceship.warpdrive).to eq(false)

      my_spaceship.reload

      expect(my_spaceship.jeanlucpicard).to eq(false)
      expect(my_spaceship.warpdrive).to eq(true)
    end

    it "updates flag with updating instance" do
      my_spaceship = SpaceshipWith2CustomFlagsColumn.new
      my_spaceship.enable_flag(:jeanlucpicard)
      my_spaceship.disable_flag(:warpdrive)
      my_spaceship.save

      expect(my_spaceship.jeanlucpicard).to eq(true)
      expect(my_spaceship.warpdrive).to eq(false)

      expect(my_spaceship.update_flag!(:jeanlucpicard, false, true)).to eq(true)
      expect(my_spaceship.update_flag!(:warpdrive, true, true)).to eq(true)

      # Updating the instance here,
      #   so it will reflect the result of the SQL update before and after reload
      expect(my_spaceship.jeanlucpicard).to eq(false)
      expect(my_spaceship.warpdrive).to eq(true)

      my_spaceship.reload

      expect(my_spaceship.jeanlucpicard).to eq(false)
      expect(my_spaceship.warpdrive).to eq(true)
    end
  end

  if ActiveRecord::VERSION::MAJOR >= 3
    describe "validations" do
      it "raises if validates_presence_of_flags is used on non-flag column" do
        spaceship = SpaceshipWithValidationsOnNonFlagsColumn.new
        expect { spaceship.valid? }.to raise_error(ArgumentError)
      end

      it "succeeds with a blank optional flag" do
        spaceship = Spaceship.new
        expect(spaceship.valid?).to eq(true)
      end

      it "fails with a nil required flag" do
        spaceship = SpaceshipWithValidationsAndCustomFlagsColumn.new
        spaceship.bits = nil
        expect(spaceship.valid?).to eq(false)
        error_message =
          if spaceship.errors.respond_to?(:messages)
            spaceship.errors.messages[:bits]
          else
            spaceship.errors.get(:bits)
          end
        expect(error_message).to eq(["can't be blank"])
      end

      it "fails with a blank required flag" do
        spaceship = SpaceshipWithValidationsAndCustomFlagsColumn.new
        expect(spaceship.valid?).to eq(false)
        error_message =
          if spaceship.errors.respond_to?(:messages)
            spaceship.errors.messages[:bits]
          else
            spaceship.errors.get(:bits)
          end
        expect(error_message).to eq(["can't be blank"])
      end

      it "succeeds with a set required flag" do
        spaceship = SpaceshipWithValidationsAndCustomFlagsColumn.new
        spaceship.warpdrive = true
        expect(spaceship.valid?).to eq(true)
      end

      it "fails with a blank required flag among 2" do
        spaceship = SpaceshipWithValidationsAnd3CustomFlagsColumn.new
        expect(spaceship.valid?).to eq(false)

        engines_error_message =
          if spaceship.errors.respond_to?(:messages)
            spaceship.errors.messages[:engines]
          else
            spaceship.errors.get(:engines)
          end
        expect(engines_error_message).to eq(["can't be blank"])

        weapons_error_message =
          if spaceship.errors.respond_to?(:messages)
            spaceship.errors.messages[:weapons]
          else
            spaceship.errors.get(:weapons)
          end
        expect(weapons_error_message).to eq(["can't be blank"])

        spaceship.warpdrive = true
        expect(spaceship.valid?).to eq(false)

        weapons_error_message =
          if spaceship.errors.respond_to?(:messages)
            spaceship.errors.messages[:weapons]
          else
            spaceship.errors.get(:weapons)
          end
        expect(weapons_error_message).to eq(["can't be blank"])
      end

      it "succeeds with a set required flag among 2" do
        spaceship = SpaceshipWithValidationsAnd3CustomFlagsColumn.new
        spaceship.warpdrive = true
        spaceship.photon = true
        expect(spaceship.valid?).to eq(true)
      end
    end
  end
end

