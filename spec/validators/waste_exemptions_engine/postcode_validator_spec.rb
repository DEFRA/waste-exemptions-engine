# frozen_string_literal: true

require "rails_helper"

module Test
  PostcodeValidatable = Struct.new(:postcode) do
    include ActiveModel::Validations

    validates :postcode, "waste_exemptions_engine/postcode": true
  end
end

module WasteExemptionsEngine
  RSpec.describe PostcodeValidator, type: :model do
    valid_postcode = "BS1 5AH"
    invalid_postcode = "foo"
    postcode_without_addresses = "AA1 1AA"

    describe "#validate_each" do
      context "when the postcode is valid", :vcr do
        before { VCR.insert_cassette("postcode_valid") }
        after { VCR.eject_cassette }

        it_behaves_like "a valid record", Test::PostcodeValidatable.new(valid_postcode)
      end

      context "when the postcode is not valid" do
        context "when the postcode is not present" do
          validatable = Test::PostcodeValidatable.new
          error_message = Helpers::Translator.error_message(validatable, :postcode, :blank)

          it_behaves_like "an invalid record", validatable, :postcode, error_message
        end

        context "when the postcode is not correctly formatted" do
          validatable = Test::PostcodeValidatable.new(invalid_postcode)
          error_message = Helpers::Translator.error_message(validatable, :postcode, :wrong_format)

          it_behaves_like "an invalid record", validatable, :postcode, error_message
        end

        context "when the postcode does not have associated adresses", :vcr do
          before { VCR.insert_cassette("postcode_no_matches") }
          after { VCR.eject_cassette }

          validatable = Test::PostcodeValidatable.new(postcode_without_addresses)
          error_message = Helpers::Translator.error_message(validatable, :postcode, :no_results)

          it_behaves_like "an invalid record", validatable, :postcode, error_message
        end
      end
    end
  end
end
