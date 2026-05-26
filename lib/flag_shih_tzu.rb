# Would like to support other database adapters so no more hard dependency on Active Record.
require "version_gem"
require_relative "flag_shih_tzu/version"

require "flag_shih_tzu/validators"

module FlagShihTzu
  # taken from ActiveRecord::ConnectionAdapters::Column
  TRUE_VALUES = [true, 1, "1", "t", "T", "true", "TRUE"]
  FALSE_VALUES = [false, 0, "0", "f", "F", "false", "FALSE"]
  NIL_VALUES = [nil, "", "nil", "NULL", "null"]

  DEFAULT_COLUMN_NAME = "flags"
  DEFAULT_CHECK_FOR_COLUMN = false
  DEFAULT_FLAG_QUERY_MODE = :bit_operator
  DEFAULT_BIT_WIDTH = 1
  FLAG_ADAPTER_CLASS_NAMES = {
    "mysql" => "Mysql2Adapter",
    "mysql2" => "Mysql2Adapter",
    "postgis" => "PostgreSQLAdapter",
    "postgresql" => "PostgreSQLAdapter",
    "sqlite" => "SQLite3Adapter",
    "sqlite3" => "SQLite3Adapter",
    "trilogy" => "TrilogyAdapter",
  }.freeze
  FLAG_ADAPTER_REQUIRE_NAMES = {
    "mysql" => "mysql2",
    "postgis" => "postgresql",
  }.freeze
  FLAG_COLUMN_ONLY_ASSIGNMENT_ADAPTERS = ["postgis", "postgresql", "sqlite", "sqlite3"].freeze

  class Configuration
    attr_accessor :default_check_for_column,
      :default_flag_query_mode

    def initialize
      @default_check_for_column = DEFAULT_CHECK_FOR_COLUMN
      @default_flag_query_mode = DEFAULT_FLAG_QUERY_MODE
    end
  end

  CONFIGURATION = Configuration.new

  class << self
    def included(base)
      base.extend(ClassMethods)
      base.class_attribute(:flag_options) unless defined?(base.flag_options)
      base.class_attribute(:flag_mapping) unless defined?(base.flag_mapping)
      base.class_attribute(:flag_columns) unless defined?(base.flag_columns)
    end

    def default_check_for_column
      CONFIGURATION.default_check_for_column
    end

    def default_check_for_column=(value)
      CONFIGURATION.default_check_for_column = value
    end

    def default_flag_query_mode
      CONFIGURATION.default_flag_query_mode
    end

    def default_flag_query_mode=(value)
      CONFIGURATION.default_flag_query_mode = value
    end
  end

  class IncorrectFlagColumnException < StandardError; end
  class NoSuchFlagQueryModeException < StandardError; end
  class NoSuchFlagException < StandardError; end
  class DuplicateFlagColumnException < StandardError; end
  class InvalidFlagValueException < StandardError; end

  class BooleanEncoder
    class << self
      def bit_width
        1
      end

      def mask(flag_key)
        1 << (flag_key - 1)
      end

      def read(bits, flag_mask)
        (bits & flag_mask) != 0
      end

      def write(bits, flag_mask, value)
        true_value?(value) ? bits | flag_mask : bits & ~flag_mask
      end

      def disabled_value(bits, flag_mask)
        !read(bits, flag_mask)
      end

      def changed?(from_bits, to_bits, flag_mask)
        (from_bits & flag_mask) != (to_bits & flag_mask)
      end

      def enabled_sql_value(flag_mask)
        flag_mask
      end

      def disabled_sql_value(_flag_mask)
        0
      end

      def sql_value_for(flag_mask, enabled)
        enabled ? enabled_sql_value(flag_mask) : disabled_sql_value(flag_mask)
      end

      def sql_operator_for(enabled)
        enabled ? "| " : "& ~"
      end

      def sql_operand_for(flag_mask, _enabled)
        flag_mask
      end

      def matches?(bits, flag_mask, enabled)
        (bits & flag_mask) == sql_value_for(flag_mask, enabled)
      end

      private

      def true_value?(value)
        FlagShihTzu::TRUE_VALUES.include?(value)
      end
    end
  end

  class TriStateEncoder
    class << self
      def bit_width
        2
      end

      def mask(flag_key)
        ((1 << bit_width) - 1) << ((flag_key - 1) * bit_width)
      end

      def read(bits, flag_mask)
        raw_value = bits & flag_mask
        return if raw_value == flag_mask

        raw_value != 0
      end

      def write(bits, flag_mask, value)
        cleared_bits = bits & ~flag_mask
        cleared_bits | encoded_value(flag_mask, value)
      end

      def disabled_value(bits, flag_mask)
        value = read(bits, flag_mask)
        value.nil? ? nil : !value
      end

      def changed?(from_bits, to_bits, flag_mask)
        (from_bits & flag_mask) != (to_bits & flag_mask)
      end

      def enabled_sql_value(flag_mask)
        low_bit(flag_mask)
      end

      def disabled_sql_value(_flag_mask)
        0
      end

      def nil_sql_value(flag_mask)
        flag_mask
      end

      def sql_value_for(flag_mask, enabled)
        return nil_sql_value(flag_mask) if enabled.nil?

        enabled ? enabled_sql_value(flag_mask) : disabled_sql_value(flag_mask)
      end

      def sql_operator_for(_enabled)
        "& ~"
      end

      def sql_operand_for(flag_mask, enabled)
        "#{flag_mask} | #{sql_value_for(flag_mask, enabled)}"
      end

      def matches?(bits, flag_mask, enabled)
        (bits & flag_mask) == sql_value_for(flag_mask, enabled)
      end

      private

      def encoded_value(flag_mask, value)
        return enabled_sql_value(flag_mask) if FlagShihTzu::TRUE_VALUES.include?(value)
        return disabled_sql_value(flag_mask) if FlagShihTzu::FALSE_VALUES.include?(value)
        return nil_sql_value(flag_mask) if FlagShihTzu::NIL_VALUES.include?(value)

        raise InvalidFlagValueException,
          %[Invalid tri-state flag value "#{value.inspect}"; expected true, false, or nil]
      end

      def low_bit(flag_mask)
        flag_mask & -flag_mask
      end
    end
  end

  module ClassMethods
    def has_flags(*args)
      flag_hash, opts = parse_flag_options(*args)
      opts =
        {
          named_scopes: true,
          column: DEFAULT_COLUMN_NAME,
          flag_query_mode: FlagShihTzu.default_flag_query_mode,
          strict: false,
          check_for_column: FlagShihTzu.default_check_for_column,
          allow_overwrite: false,
          bit_width: DEFAULT_BIT_WIDTH,
        }.update(opts)
      opts[:encoder] = flag_encoder_for(opts[:bit_width], opts[:encoder])
      if !valid_flag_column_name?(opts[:column])
        warn(%[FlagShihTzu says: Please use a String to designate column names! I see you here: #{caller(1..1).first}])
        opts[:column] = opts[:column].to_s
      end
      colmn = opts[:column]
      if opts[:check_for_column] && active_record_class? && !check_flag_column(colmn)
        warn(
          %[FlagShihTzu says: Flag column #{colmn} appears to be missing!
To turn off this warning set check_for_column: false in has_flags definition here: #{caller(1..1).first}],
        )
        return
      end

      # options are stored in a class level hash and apply per-column
      self.flag_options ||= {}
      flag_options[colmn] = opts

      # the mappings are stored in this class level hash and apply per-column
      self.flag_mapping ||= {}
      # If we already have an instance of the same column in the flag_mapping,
      #   then there is a double definition on a column
      if opts[:strict] && !self.flag_mapping[colmn].nil?
        raise DuplicateFlagColumnException
      end
      flag_mapping[colmn] ||= {}

      # keep track of which flag columns are defined on this class
      self.flag_columns ||= []
      self.flag_columns << colmn

      flag_hash.each do |flag_key, flag_name|
        unless valid_flag_key?(flag_key)
          raise ArgumentError,
            %[has_flags: flag keys should be positive integers, and #{flag_key} is not]
        end
        unless valid_flag_name?(flag_name)
          raise ArgumentError,
            %[has_flags: flag names should be symbols, and #{flag_name} is not]
        end
        flag_mask = opts[:encoder].mask(flag_key)
        # next if method already defined by flag_shih_tzu
        next if flag_mapping[colmn][flag_name] & flag_mask
        if method_defined?(flag_name)
          if opts[:allow_overwrite]
            remove_existing_flag_methods(flag_name)
          else
            raise ArgumentError,
              %[has_flags: flag name #{flag_name} already defined, please choose different name]
          end
        end

        flag_mapping[colmn][flag_name] = flag_mask

        class_eval(<<-EVAL, __FILE__, __LINE__ + 1)
          def #{flag_name}
            flag_enabled?(:#{flag_name}, "#{colmn}")
          end
          alias :#{flag_name}? :#{flag_name}

          def #{flag_name}=(value)
            set_flag_value(:#{flag_name}, value, "#{colmn}")
          end

          def not_#{flag_name}
            flag_disabled?(:#{flag_name}, "#{colmn}")
          end
          alias :not_#{flag_name}? :not_#{flag_name}

          def not_#{flag_name}=(value)
            set_flag_value(:#{flag_name}, inverse_flag_value(value, "#{colmn}"), "#{colmn}")
          end

          def #{flag_name}_changed?
            if colmn_changes = changes["#{colmn}"]
              flag_bit = self.class.flag_mapping["#{colmn}"][:#{flag_name}]
              self.class.send(:flag_encoder_for_column, "#{colmn}").changed?(colmn_changes[0], colmn_changes[1], flag_bit)
            else
              false
            end
          end

          def #{flag_name}_nil?
            flag_enabled?(:#{flag_name}, "#{colmn}").nil?
          end

        EVAL

        if active_record_class?
          class_eval(<<-EVAL, __FILE__, __LINE__ + 1)
            def self.#{flag_name}_condition(options = {})
              sql_condition_for_flag(
                :#{flag_name},
                "#{colmn}",
                true,
                options[:table_alias] || table_name
              )
            end

            def self.not_#{flag_name}_condition(options = {})
              sql_condition_for_flag(
                :#{flag_name},
                "#{colmn}",
                false,
                options[:table_alias] || table_name
              )
            end

            def self.#{flag_name}_nil_condition(options = {})
              sql_condition_for_flag(
                :#{flag_name},
                "#{colmn}",
                nil,
                options[:table_alias] || table_name
              )
            end

            def self.set_#{flag_name}_sql
              sql_set_for_flag(:#{flag_name}, "#{colmn}", true)
            end

            def self.unset_#{flag_name}_sql
              sql_set_for_flag(:#{flag_name}, "#{colmn}", false)
            end

            def self.clear_#{flag_name}_sql
              sql_set_for_flag(:#{flag_name}, "#{colmn}", nil)
            end
          EVAL

          # Define the named scopes if the user wants them and AR supports it
          if flag_options[colmn][:named_scopes]
            if ActiveRecord::VERSION::MAJOR == 2 && respond_to?(:named_scope)
              class_eval(<<-EVAL, __FILE__, __LINE__ + 1)
                named_scope :#{flag_name}, lambda {
                  { conditions: #{flag_name}_condition }
                }
                named_scope :not_#{flag_name}, lambda {
                  { conditions: not_#{flag_name}_condition }
                }
              EVAL
            elsif respond_to?(:scope)
              # Prevent deprecation notices on Rails 3
              #   when using +named_scope+ instead of +scope+.
              # Prevent deprecation notices on Rails 4
              #   when using +conditions+ instead of +where+.
              class_eval(<<-EVAL, __FILE__, __LINE__ + 1)
                scope :#{flag_name}, lambda {
                  where(#{flag_name}_condition)
                }
                scope :not_#{flag_name}, lambda {
                  where(not_#{flag_name}_condition)
                }
                scope :#{flag_name}_nil, lambda {
                  where(#{flag_name}_nil_condition)
                }
              EVAL
            end
          end

          if method_defined?(:saved_changes)
            class_eval(<<-EVAL, __FILE__, __LINE__ + 1)
              def saved_change_to_#{flag_name}?
                if colmn_changes = saved_changes["#{colmn}"]
                  flag_bit = self.class.flag_mapping["#{colmn}"][:#{flag_name}]
                  self.class.send(:flag_encoder_for_column, "#{colmn}").changed?(colmn_changes[0], colmn_changes[1], flag_bit)
                else
                  false
                end
              end
            EVAL
          end
        end

        # Define bang methods when requested
        if flag_options[colmn][:bang_methods]
          class_eval(<<-EVAL, __FILE__, __LINE__ + 1)
            def #{flag_name}!
              enable_flag(:#{flag_name}, "#{colmn}")
            end

            def not_#{flag_name}!
              disable_flag(:#{flag_name}, "#{colmn}")
            end

            def clear_#{flag_name}!
              clear_flag(:#{flag_name}, "#{colmn}")
            end
          EVAL
        end
      end

      if colmn != DEFAULT_COLUMN_NAME
        class_eval(<<-EVAL, __FILE__, __LINE__ + 1)

          def all_#{colmn}
            all_flags("#{colmn}")
          end

          def #{colmn}=(value)
            set_flags(value, "#{colmn}")
          end

          def selected_#{colmn}
            selected_flags("#{colmn}")
          end

          def select_all_#{colmn}
            select_all_flags("#{colmn}")
          end

          def unselect_all_#{colmn}
            unselect_all_flags("#{colmn}")
          end

          # useful for a form builder
          def selected_#{colmn}=(chosen_flags)
            unselect_all_flags("#{colmn}")
            return if chosen_flags.nil?
            chosen_flags.each do |selected_flag|
              enable_flag(selected_flag.to_sym, "#{colmn}") if selected_flag.present?
            end
          end

          def has_#{colmn.singularize}?
            not selected_#{colmn}.empty?
          end

          def chained_#{colmn}_with_signature(*args)
            chained_flags_with_signature("#{colmn}", *args)
          end

          def as_#{colmn.singularize}_collection(*args)
            as_flag_collection("#{colmn}", *args)
          end

          def #{colmn}_as_attributes(*args)
            flags_as_attributes("#{colmn}", *args)
          end

        EVAL
      end

      if active_record_class?
        class_eval(<<-EVAL, __FILE__, __LINE__ + 1)
          def self.#{colmn.singularize}_values_for(*flag_names)
            values = []
            flag_names.each do |flag_name|
              if respond_to?(flag_name)
                values_for_flag = send(:sql_in_for_flag, flag_name, "#{colmn}")
                values = if values.present?
                  values & values_for_flag
                else
                  values_for_flag
                end
              end
            end

            values.sort
          end
        EVAL
      end
    end

    def check_flag(flag, colmn)
      unless colmn.is_a?(String)
        raise ArgumentError,
          %[Column name "#{colmn}" for flag "#{flag}" is not a string]
      end
      if flag_mapping[colmn].nil? || !flag_mapping[colmn].include?(flag)
        raise ArgumentError,
          %[Invalid flag "#{flag}"]
      end
    end

    # Returns SQL statement to enable/disable flag.
    # Automatically determines the correct column.
    def set_flag_sql(flag, value, colmn = nil, custom_table_name = table_name)
      colmn = determine_flag_colmn_for(flag) if colmn.nil?
      sql_set_for_flag(flag, colmn, value, custom_table_name)
    end

    def determine_flag_colmn_for(flag)
      return DEFAULT_COLUMN_NAME if flag_mapping.nil?
      flag_mapping.each_pair do |colmn, mapping|
        return colmn if mapping.include?(flag)
      end
      raise NoSuchFlagException.new(
        %[determine_flag_colmn_for: Couldn't determine column for your flags!],
      )
    end

    def chained_flags_with(column = DEFAULT_COLUMN_NAME, *args)
      if ActiveRecord::VERSION::MAJOR >= 3
        where(chained_flags_condition(column, *args))
      else
        all(conditions: chained_flags_condition(column, *args))
      end
    end

    def chained_flags_condition(colmn = DEFAULT_COLUMN_NAME, *args)
      if flag_options[colmn][:flag_query_mode] == :bit_operator
        conditions = args.map do |flag|
          flag, enabled = flag_enabled_query(flag)
          check_flag(flag, colmn)
          flag_value = flag_mapping[colmn][flag]
          expected_value = flag_encoder_for_column(colmn).sql_value_for(flag_value, enabled)
          "#{flag_full_column_name(table_name, colmn)} & #{flag_value} = #{expected_value}"
        end
        return %[(#{conditions.join(" AND ")})]
      end

      %[(#{flag_full_column_name(table_name, colmn)} in (#{chained_flags_values(colmn, *args).join(",")}))]
    end

    def flag_keys(colmn = DEFAULT_COLUMN_NAME)
      flag_mapping[colmn].keys
    end

    private

    def remove_existing_flag_methods(flag_name)
      generated_flag_method_names(flag_name).each do |method_name|
        remove_method(method_name) if method_defined?(method_name, false)
      end
    end

    def generated_flag_method_names(flag_name)
      [
        flag_name,
        "#{flag_name}?".to_sym,
        "#{flag_name}=".to_sym,
        "not_#{flag_name}".to_sym,
        "not_#{flag_name}?".to_sym,
        "not_#{flag_name}=".to_sym,
        "#{flag_name}_changed?".to_sym,
        "#{flag_name}_nil?".to_sym,
        "saved_change_to_#{flag_name}?".to_sym,
        "#{flag_name}!".to_sym,
        "not_#{flag_name}!".to_sym,
        "clear_#{flag_name}!".to_sym,
      ]
    end

    def flag_encoder_for(bit_width, encoder)
      return encoder if encoder
      return BooleanEncoder if bit_width == 1
      return TriStateEncoder if bit_width == 2

      raise ArgumentError,
        %[has_flags: bit_width #{bit_width} requires an encoder]
    end

    def flag_encoder_for_column(colmn)
      flag_options.fetch(colmn).fetch(:encoder)
    end

    def flag_full_column_name(table, column)
      "#{flag_quote_table_name(table)}.#{flag_quote_column_name(column)}"
    end

    def flag_full_column_name_for_assignment(table, column)
      if ActiveRecord::VERSION::MAJOR <= 3 || FLAG_COLUMN_ONLY_ASSIGNMENT_ADAPTERS.include?(flag_connection_adapter_name)
        # If you're trying to do multi-table updates with Rails < 4, sorry - you're out of luck.
        flag_quote_column_name(column)
      else
        flag_quote_table_name("#{table}.#{column}")
      end
    end

    def flag_quote_column_name(column)
      adapter_class = flag_connection_adapter_class
      return adapter_class.quote_column_name(column) if adapter_class

      flag_fallback_quote_name(column)
    end

    def flag_quote_table_name(table)
      adapter_class = flag_connection_adapter_class
      return adapter_class.quote_table_name(table) if adapter_class

      flag_fallback_quote_name(table)
    end

    def flag_connection_adapter_class
      adapter_name = flag_connection_adapter_name
      class_name = FLAG_ADAPTER_CLASS_NAMES[adapter_name]
      return if class_name.nil?

      require "active_record/connection_adapters/#{FLAG_ADAPTER_REQUIRE_NAMES.fetch(adapter_name, adapter_name)}_adapter"
      ActiveRecord::ConnectionAdapters.const_get(class_name)
    rescue LoadError, NameError
      nil
    end

    def flag_connection_adapter_name
      if respond_to?(:connection_db_config)
        connection_db_config.adapter.to_s.downcase
      elsif connection_pool.respond_to?(:db_config)
        connection_pool.db_config.adapter.to_s.downcase
      elsif connection_pool.respond_to?(:spec)
        connection_pool.spec.config[:adapter].to_s.downcase
      else
        connection.adapter_name.to_s.downcase
      end
    end

    def flag_fallback_quote_name(name)
      name.to_s.split(".").map { |part| %("#{part.gsub('"', '""')}") }.join(".")
    end

    def flag_enabled_query(flag)
      flag_name = flag.to_s
      return [flag_name[4..-1].to_sym, false] if flag_name.start_with?("not_")

      [flag, true]
    end

    def flag_value_range_for_column(colmn)
      max = flag_mapping[colmn].values.max
      Range.new(0, max | (max - 1))
    end

    def chained_flags_values(colmn, *args)
      val = flag_value_range_for_column(colmn).to_a
      args.each do |flag|
        flag, enabled = flag_enabled_query(flag)
        check_flag(flag, colmn)
        flag_values = sql_in_for_flag(flag, colmn)
        val = if enabled
          val & flag_values
        else
          val - flag_values
        end
      end
      val
    end

    def parse_flag_options(*args)
      options = args.shift
      add_options = if args.size >= 1
        args.shift
      else
        options
          .keys
          .select { |key| !key.is_a?(Integer) }
          .each_with_object({}) do |key, hash|
            hash[key] = options.delete(key)
        end
      end
      [options, add_options]
    end

    def check_flag_column(colmn, custom_table_name = table_name)
      # If you aren't using ActiveRecord (eg. you are outside rails)
      #   then do not fail here
      # If you are using ActiveRecord then you only want to check for the
      #   table if the table exists so it won't fail pre-migration
      has_ar = !!defined?(ActiveRecord) && respond_to?(:descends_from_active_record?)
      # Supposedly Rails 2.3 takes care of this, but this precaution
      #   is needed for backwards compatibility
      has_table = if has_ar
        if ::ActiveRecord::VERSION::MAJOR >= 5
          connection.data_sources.include?(custom_table_name)
        else
          connection.tables.include?(custom_table_name)
        end
      else
        true
      end
      if has_table
        found_column = columns.detect { |column| column.name == colmn }
        # If you have not yet run the migration that adds the 'flags' column
        #   then we don't want to fail,
        #   because we need to be able to run the migration
        # If the column is there but is of the wrong type,
        #   then we must fail, because flag_shih_tzu will not work
        if found_column.nil?
          warn(
            %[Error: Column "#{colmn}" doesn't exist on table "#{custom_table_name}". Did you forget to run migrations?],
          )
          return false
        elsif found_column.type != :integer
          raise IncorrectFlagColumnException.new(
            %[Table "#{custom_table_name}" must have an integer column named "#{colmn}" in order to use FlagShihTzu.],
          )
        end
      else
        # ActiveRecord gem may not have loaded yet?
        warn(
          %[FlagShihTzu#has_flags: Table "#{custom_table_name}" doesn't exist.  Have all migrations been run?],
        ) if has_ar
        return false
      end

      true

      # Quietly ignore NoDatabaseErrors - presumably we're being run during, eg, `rails db:create`.
      # NoDatabaseError was only introduced in Rails 4.1, which is why this error-handling is a bit convoluted.
    rescue StandardError => e
      if defined?(ActiveRecord::NoDatabaseError) && e.is_a?(ActiveRecord::NoDatabaseError)
        true
      else
        raise
      end
    end

    def sql_condition_for_flag(flag, colmn, enabled = true, custom_table_name = table_name)
      check_flag(flag, colmn)
      flag_mask = flag_mapping[colmn][flag]
      encoder = flag_encoder_for_column(colmn)

      if flag_options[colmn][:flag_query_mode] == :bit_operator
        # use & bit operator directly in the SQL query.
        # This has the drawback of not using an index on the flags colum.
        %[(#{flag_full_column_name(custom_table_name, colmn)} & #{flag_mask} = #{encoder.sql_value_for(flag_mask, enabled)})]
      elsif flag_options[colmn][:flag_query_mode] == :in_list
        # use IN() operator in the SQL query.
        # This has the drawback of becoming a big query
        #   when you have lots of flags.
        neg = enabled ? "" : "not "
        %[(#{flag_full_column_name(custom_table_name, colmn)} #{neg}in (#{sql_in_for_flag(flag, colmn).join(",")}))]
      else
        raise NoSuchFlagQueryModeException
      end
    end

    # returns an array of integers suitable for a SQL IN statement.
    def sql_in_for_flag(flag, colmn)
      flag_mask = flag_mapping[colmn][flag]
      encoder = flag_encoder_for_column(colmn)
      flag_value_range_for_column(colmn).select { |bits| encoder.matches?(bits, flag_mask, true) }
    end

    def sql_set_for_flag(flag, colmn, enabled = true, custom_table_name = table_name)
      check_flag(flag, colmn)
      lhs_name = flag_full_column_name_for_assignment(custom_table_name, colmn)
      rhs_name = flag_full_column_name(custom_table_name, colmn)
      flag_mask = flag_mapping[colmn][flag]
      encoder = flag_encoder_for_column(colmn)
      "#{lhs_name} = #{rhs_name} #{encoder.sql_operator_for(enabled)}#{encoder.sql_operand_for(flag_mask, enabled)}"
    end

    def valid_flag_key?(flag_key)
      flag_key > 0 && flag_key == flag_key.to_i
    end

    def valid_flag_name?(flag_name)
      flag_name.is_a?(Symbol)
    end

    def valid_flag_column_name?(colmn)
      colmn.is_a?(String)
    end

    # Returns the correct method to create a named scope.
    # Use to prevent deprecation notices on Rails 3
    #   when using +named_scope+ instead of +scope+.
    def named_scope_method
      # Can't use respond_to because both AR 2 and 3
      #   respond to both +scope+ and +named_scope+.
      (ActiveRecord::VERSION::MAJOR == 2) ? :named_scope : :scope
    end

    def active_record_class?
      ancestors.include?(ActiveRecord::Base)
    end
  end

  # Performs the bitwise operation so the flag will return +true+.
  def enable_flag(flag, colmn = nil)
    colmn = determine_flag_colmn_for(flag) if colmn.nil?
    self.class.check_flag(flag, colmn)

    set_flag_value(flag, true, colmn)
  end

  # Performs the bitwise operation so the flag will return +false+.
  def disable_flag(flag, colmn = nil)
    colmn = determine_flag_colmn_for(flag) if colmn.nil?
    self.class.check_flag(flag, colmn)

    set_flag_value(flag, false, colmn)
  end

  # Performs the bitwise operation so the flag will return +nil+ when supported.
  def clear_flag(flag, colmn = nil)
    colmn = determine_flag_colmn_for(flag) if colmn.nil?
    self.class.check_flag(flag, colmn)

    set_flag_value(flag, nil, colmn)
  end

  def flag_enabled?(flag, colmn = nil)
    colmn = determine_flag_colmn_for(flag) if colmn.nil?
    self.class.check_flag(flag, colmn)

    flag_encoder_for_column(colmn).read(flags(colmn), self.class.flag_mapping[colmn][flag])
  end

  def flag_disabled?(flag, colmn = nil)
    colmn = determine_flag_colmn_for(flag) if colmn.nil?
    self.class.check_flag(flag, colmn)

    flag_encoder_for_column(colmn).disabled_value(flags(colmn), self.class.flag_mapping[colmn][flag])
  end

  def flags(colmn = DEFAULT_COLUMN_NAME)
    self[colmn] || 0
  end

  def flags=(value)
    set_flags(value)
  end

  def set_flags(value, colmn = DEFAULT_COLUMN_NAME)
    case value
    when Array
      set_selected_flags(value, colmn)
    when Hash
      set_flag_attributes(value, colmn)
    else
      self[colmn] = value
    end
  end

  def all_flags(colmn = DEFAULT_COLUMN_NAME)
    flag_mapping[colmn].keys
  end

  def selected_flags(colmn = DEFAULT_COLUMN_NAME)
    all_flags(colmn)
      .map { |flag_name| send(flag_name) ? flag_name : nil }
      .compact
  end

  # Useful for a form builder
  # use selected_#{column}= for custom column names.
  def selected_flags=(chosen_flags)
    set_selected_flags(chosen_flags, DEFAULT_COLUMN_NAME)
  end

  def select_all_flags(colmn = DEFAULT_COLUMN_NAME)
    all_flags(colmn).each do |flag|
      enable_flag(flag, colmn)
    end
  end

  def unselect_all_flags(colmn = DEFAULT_COLUMN_NAME)
    all_flags(colmn).each do |flag|
      disable_flag(flag, colmn)
    end
  end

  def has_flag?(colmn = DEFAULT_COLUMN_NAME)
    !selected_flags(colmn).empty?
  end

  # returns true if successful
  # third parameter allows you to specify that `self` should
  #   also have its in-memory flag attribute updated.
  def update_flag!(flag, value, update_instance = false)
    flag_value = normalized_flag_value(value, determine_flag_colmn_for(flag.to_sym))
    sql = self.class.set_flag_sql(flag.to_sym, flag_value)
    if update_instance
      set_flag_value(flag.to_sym, flag_value)
    end
    if ActiveRecord::VERSION::MAJOR <= 3
      self.class
        .update_all(sql, self.class.primary_key => id) == 1
    else
      self.class
        .where("#{self.class.primary_key} = ?", id)
        .update_all(sql) == 1
    end
  end

  # Use with chained_flags_with to find records with specific flags
  #   set to the same values as on this record.
  # For a record that has sent_warm_up_email = true and the other flags false:
  #
  #     user.chained_flags_with_signature
  #     => [:sent_warm_up_email,
  #         :not_follow_up_called,
  #         :not_sent_final_email,
  #         :not_scheduled_appointment]
  #     User.chained_flags_with("flags", *user.chained_flags_with_signature)
  #     => the set of Users that have the same flags set as user.
  #
  def chained_flags_with_signature(colmn = DEFAULT_COLUMN_NAME, *args)
    flags_to_collect = args.empty? ? all_flags(colmn) : args
    truthy_and_chosen =
      selected_flags(colmn)
        .select { |flag| flags_to_collect.include?(flag) }
    truthy_and_chosen.concat(
      collect_flags(*flags_to_collect) do |memo, flag|
        memo << "not_#{flag}".to_sym unless truthy_and_chosen.include?(flag)
      end,
    )
  end

  # Use with a checkbox form builder, like rails' or simple_form's
  # :selected_flags, used in the example below, is a method defined
  #   by flag_shih_tzu for bulk setting flags like this:
  #
  #     form_for @user do |f|
  #       f.collection_check_boxes(:selected_flags,
  #         f.object.as_flag_collection("flags",
  #             :sent_warm_up_email,
  #             :not_follow_up_called),
  #         :first,
  #         :last)
  #     end
  #
  def as_flag_collection(colmn = DEFAULT_COLUMN_NAME, *args)
    flags_to_collect = args.empty? ? all_flags(colmn) : args
    collect_flags(*flags_to_collect) do |memo, flag|
      memo << [flag, flag_enabled?(flag, colmn)]
    end
  end

  def flags_as_attributes(colmn = nil, *args)
    columns = colmn.nil? ? self.class.flag_columns : [colmn]
    columns.each_with_object({}) do |column, memo|
      flags_to_collect = args.empty? ? all_flags(column) : args
      flags_to_collect.each do |flag|
        memo[flag] = flag_enabled?(flag, column)
      end
    end
  end

  def attributes_with_flags
    flags_as_attributes.each_with_object(attributes.dup) do |(flag, enabled), attrs|
      attrs[flag.to_s] = enabled
    end
  end

  private

  def set_selected_flags(chosen_flags, colmn)
    unselect_all_flags(colmn)
    return if chosen_flags.nil?

    chosen_flags.each do |selected_flag|
      next unless selected_flag.present?

      flag, enabled = self.class.send(:flag_enabled_query, selected_flag.to_sym)
      enabled ? enable_flag(flag, colmn) : disable_flag(flag, colmn)
    end
  end

  def set_flag_attributes(flag_attributes, colmn)
    flag_attributes.each_pair do |flag, value|
      set_flag_value(flag.to_sym, value, colmn)
    end
  end

  def collect_flags(*args)
    args.each_with_object([]) do |flag, memo|
      yield memo, flag
    end
  end

  def get_bit_for(flag, colmn)
    flags(colmn) & self.class.flag_mapping[colmn][flag]
  end

  def set_flag_value(flag, value, colmn = nil)
    colmn = determine_flag_colmn_for(flag) if colmn.nil?
    self.class.check_flag(flag, colmn)

    flag_mask = self.class.flag_mapping[colmn][flag]
    self[colmn] = flag_encoder_for_column(colmn).write(flags(colmn), flag_mask, value)
  end

  def normalized_flag_value(value, colmn)
    return true if FlagShihTzu::TRUE_VALUES.include?(value)
    return false if FlagShihTzu::FALSE_VALUES.include?(value)
    return if FlagShihTzu::NIL_VALUES.include?(value) && flag_encoder_for_column(colmn).bit_width > 1

    false
  end

  def inverse_flag_value(value, colmn)
    normalized = normalized_flag_value(value, colmn)
    normalized.nil? ? nil : !normalized
  end

  def flag_encoder_for_column(colmn)
    self.class.send(:flag_encoder_for_column, colmn)
  end

  def determine_flag_colmn_for(flag)
    self.class.determine_flag_colmn_for(flag)
  end
end

FlagShihTzu::Version.class_eval do
  extend VersionGem::Basic
end
