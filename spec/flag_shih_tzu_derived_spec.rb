# frozen_string_literal: true

require "spec_helper"

RSpec.describe FlagShihTzu do
  let(:spaceship) { SpaceCarrier.new }

  it "enables a flag" do
    spaceship.enable_flag(:warpdrive)
    expect(spaceship.flag_enabled?(:warpdrive)).to be(true)
  end

  it "disables a flag" do
    spaceship.enable_flag(:warpdrive)
    expect(spaceship.flag_enabled?(:warpdrive)).to be(true)

    spaceship.disable_flag(:warpdrive)
    expect(spaceship.flag_disabled?(:warpdrive)).to be(true)
  end

  it "stores the flags correctly" do
    spaceship.enable_flag(:warpdrive)
    spaceship.disable_flag(:shields)
    spaceship.enable_flag(:electrolytes)

    spaceship.save!
    spaceship.reload

    expect(spaceship.flags).to eq(5)
    expect(spaceship.flag_enabled?(:warpdrive)).to be(true)
    expect(spaceship.flag_enabled?(:shields)).to be(false)
    expect(spaceship.flag_enabled?(:electrolytes)).to be(true)
  end

  it "leaves the flag enabled when enable_flag is called twice" do
    2.times do
      spaceship.enable_flag(:warpdrive)
      expect(spaceship.flag_enabled?(:warpdrive)).to be(true)
    end
  end

  it "leaves the flag disabled when disable_flag is called twice" do
    2.times do
      spaceship.disable_flag(:warpdrive)
      expect(spaceship.flag_enabled?(:warpdrive)).to be(false)
    end
  end

  it "defines an attribute reader method" do
    expect(spaceship.warpdrive?).to be(false)
  end

  it "defines an attribute writer method" do
    spaceship.warpdrive = true
    expect(spaceship.warpdrive).to be(true)
  end

  it "respects true values like ActiveRecord" do
    [true, 1, "1", "t", "T", "true", "TRUE"].each do |true_value|
      spaceship.warpdrive = true_value
      expect(spaceship.warpdrive).to be(true)
    end

    [false, 0, "0", "f", "F", "false", "FALSE"].each do |false_value|
      spaceship.warpdrive = false_value
      expect(spaceship.warpdrive).to be(false)
    end
  end

  describe "bang methods" do
    it "defines bang methods when enabled" do
      spaceship = SpaceshipWithBangMethods.new
      spaceship.warpdrive!
      expect(spaceship.warpdrive).to be(true)
      spaceship.not_warpdrive!
      expect(spaceship.warpdrive).to be(false)
    end

    it "returns a sql set method for flag" do
      expect(Spaceship.send(:sql_set_for_flag, :warpdrive, "flags", true))
        .to eq('"flags" = "spaceships"."flags" | 1')
      expect(Spaceship.send(:sql_set_for_flag, :warpdrive, "flags", false))
        .to eq('"flags" = "spaceships"."flags" & ~1')
    end
  end
end
