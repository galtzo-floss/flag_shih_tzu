# frozen_string_literal: true

# For code coverage, must be required before all application / gem / library code.
begin
  unless ENV["NOCOVER"]
    require "simplecov"
    SimpleCov.start do
      add_filter "/spec/"
      add_filter "/test/"
    end
  end
rescue LoadError
  # SimpleCov is optional
end

require "bundler/setup"
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
    puts "Running specs with ActiveRecord #{ActiveRecord::VERSION::STRING}"
  end

  # Wrap each test in a transaction
  config.around(:each) do |example|
    ActiveRecord::Base.connection.transaction do
      example.run
      raise ActiveRecord::Rollback
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
