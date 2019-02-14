# frozen_string_literal: true

require "rails_helper"

module Test
  PhoneNumberValidatable = Struct.new(:phone_number) do
    include ActiveModel::Validations

    validates :phone_number, "waste_exemptions_engine/phone_number": true
  end
end

module WasteExemptionsEngine
  RSpec.describe PhoneNumberValidator, type: :model do
    valid_number = [
      "+441234567890",
      "01234567890",
      "+441234-567-890",
      "01234.567.890",
      "+441234 567 890"
    ].sample
    too_long_number = "01234" * 3 + "9" # The max length is 15
    invalid_number = "#123"

    it_behaves_like "a validator", Test::PhoneNumberValidatable, :phone_number, valid_number
    it_behaves_like "a presence validator", Test::PhoneNumberValidatable, :phone_number
    it_behaves_like "a length validator", Test::PhoneNumberValidatable, :phone_number, too_long_number

    describe "#validate_each" do
      context "when the phone number is not valid" do
        context "because the phone number is not correctly formated" do
          validatable = Test::PhoneNumberValidatable.new(invalid_number)
          error_message = Helpers::Translator.error_message(validatable, :phone_number, :invalid_format)

          it_behaves_like "an invalid record", validatable, :phone_number, error_message
        end
      end
    end
  end
end
