# frozen_string_literal: true

# Simple test without Combustion to verify basic setup
require "bundler/setup"
require "active_record"
require "sqlite3"
require "flag_shih_tzu"

# Set up database
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
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

