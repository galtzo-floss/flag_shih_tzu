# frozen_string_literal: true

# Simple test without Combustion to verify basic setup
require "logger"
require "active_record"
if RUBY_PLATFORM == "java" && Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new("7.2")
  require "activerecord-jdbcsqlite3-adapter"
else
  require "sqlite3"
end
require "flag_shih_tzu"

adapter = "sqlite3"
if RUBY_PLATFORM == "java" && Gem::Version.new(ActiveRecord::VERSION::STRING) < Gem::Version.new("7.2")
  adapter = "jdbcsqlite3"
end

# Set up database
ActiveRecord::Base.establish_connection(
  adapter: adapter,
  database: ":memory:",
)

# Create schema
ActiveRecord::Schema.define do
  create_table :spaceships, force: true do |t|
    t.integer :flags, null: false, default: 0
  end
end

# Define model
class Spaceship < ActiveRecord::Base
  include FlagShihTzu

  has_flags 1 => :warpdrive, 2 => :shields
end

# Simple test
spaceship = Spaceship.new
spaceship.warpdrive = true
puts "✓ Can set warpdrive flag"

puts "✓ Warpdrive is: #{spaceship.warpdrive}"
puts "✓ Shields is: #{spaceship.shields}"

spaceship.save!
puts "✓ Can save spaceship"

spaceship.reload
puts "✓ Can reload spaceship"
puts "✓ Warpdrive after reload: #{spaceship.warpdrive}"

puts "\n✅ Basic setup works! Now setting up full RSpec suite..."
