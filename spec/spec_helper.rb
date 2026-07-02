# frozen_string_literal: true

# For code coverage, must be required before all application / gem / library code.
begin
  require "kettle-soup-cover"
  if Kettle::Soup::Cover::DO_COV
    require "simplecov" # Loads project-local .simplecov.
    require "kettle/soup/cover/config"
    SimpleCov.start
  end
rescue LoadError => error
  # check the error message and re-raise when unexpected
  raise error unless error.message.include?("kettle")
end

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.5")
  require "backports/2.5.0/string/delete_prefix"
end

require "logger"
require "active_record"
if RUBY_PLATFORM == "java"
  require "activerecord-jdbcsqlite3-adapter"
else
  require "sqlite3"
end
require "rspec"
require "flag_shih_tzu"

adapter = "sqlite3"
if RUBY_PLATFORM == "java" && Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new("7.2")
  adapter = "jdbcsqlite3"
end

# Set up database connection
ActiveRecord::Base.establish_connection(
  adapter: adapter,
  database: ":memory:"
)

# Suppress ActiveRecord logging
ActiveRecord::Base.logger = Logger.new(nil) if defined?(ActiveRecord::Base)
ActiveRecord::Migration.verbose = false if defined?(ActiveRecord::Migration)

# Load schema
load File.expand_path("internal/db/schema.rb", __dir__)

# Load support files (models)
Dir[File.join(__dir__, "support", "**", "*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Filter to run only certain ActiveRecord versions if needed
  config.before(:suite) do
    warn "Running specs with ActiveRecord #{ActiveRecord::VERSION::STRING}"
  end

  # Wrap each test in a transaction
  config.around do |example|
    default_check_for_column = FlagShihTzu.default_check_for_column
    default_flag_query_mode = FlagShihTzu.default_flag_query_mode
    begin
      ActiveRecord::Base.connection.transaction do
        example.run
        raise ActiveRecord::Rollback
      end
    ensure
      FlagShihTzu.default_check_for_column = default_check_for_column
      FlagShihTzu.default_flag_query_mode = default_flag_query_mode
    end
  end

  # Custom matcher for comparing arrays without order
  RSpec::Matchers.define :match_array_unordered do |expected|
    match do |actual|
      actual.is_a?(Array) && expected.is_a?(Array) &&
        actual.size == expected.size &&
        (expected - actual).empty?
    end
  end
end
