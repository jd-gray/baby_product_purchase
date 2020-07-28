require 'rails_helper'

RSpec.describe Gift, type: :model do
    describe "#validations" do
    it "requires from" do
      gift = Gift.new(
        message: "Some message",
      )

      expect(gift.valid?).to eq(false)
      expect(gift.errors[:from].size).to eq(1)
    end
  end
end
