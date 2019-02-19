# frozen_string_literal: true

require "rails_helper"

module Test
  PositionValidatable = Struct.new(:position) do
    include ActiveModel::Validations

    validates :position, "waste_exemptions_engine/position": true
  end
end

module WasteExemptionsEngine
  RSpec.describe PositionValidator, type: :model do
    valid_position = "Principle Waste Manager"
    empty_position = ""
    too_long_position = "Abcde" * 14 + "A" # The max length is 70 and this is 71.
    invalid_position = "**Invalid_@_Positione**"

    it_behaves_like "a validator", Test::PositionValidatable, :position, valid_position
    it_behaves_like "a length validator", Test::PositionValidatable, :position, too_long_position

    describe "#validate_each" do
      context "when the position is valid" do
        context "despite being blank (because the position is optional)" do
          it_behaves_like "a valid record", Test::PositionValidatable.new(empty_position)
        end
      end

      context "when the position is not valid" do
        context "because the position is not correctly formatted" do
          validatable = Test::PositionValidatable.new(invalid_position)
          error_message = Helpers::Translator.error_message(validatable, :position, :invalid)

          it_behaves_like "an invalid record", validatable, :position, error_message
        end
      end
    end
  end
end
