# frozen_string_literal: true

require "rails_helper"

module Test
  LocationValidatable = Struct.new(:location) do
    include ActiveModel::Validations

    validates :location, "waste_exemptions_engine/location": true
  end
end

module WasteExemptionsEngine
  RSpec.describe LocationValidator, type: :model do
    valid_location = %w[
      england
      northern_ireland
      scotland
      wales
    ].sample

    it_behaves_like "a validator", Test::LocationValidatable, :location, valid_location

    describe "#validate_each" do
      context "when the business type is not valid" do
        context "because the business type is not present" do
          validatable = Test::LocationValidatable.new
          error_message = Helpers::Translator.error_message(validatable, :location, :inclusion)

          it_behaves_like "an invalid record", validatable, :location, error_message
        end

        context "because the business type is not from an approved list" do
          validatable = Test::LocationValidatable.new("unexpected_location")
          error_message = Helpers::Translator.error_message(validatable, :location, :inclusion)

          it_behaves_like "an invalid record", validatable, :location, error_message
        end
      end
    end
  end
end
