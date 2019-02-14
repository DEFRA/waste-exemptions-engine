# frozen_string_literal: true

require "rails_helper"

module Test
  PersonNameValidatable = Struct.new(:name) do
    include ActiveModel::Validations

    validates :name, "waste_exemptions_engine/person_name": true
  end
end

module WasteExemptionsEngine
  RSpec.describe PersonNameValidator, type: :model do
    valid_name = "Joe Bloggs-Bloomfield, The Third."
    too_long_name = "Abcde" * 14 + "A" # The max length is 70 and this is 71.
    invalid_name = "**Invalid_@_Name**"

    it_behaves_like "a validator", Test::PersonNameValidatable, :name, valid_name
    it_behaves_like "a presence validator", Test::PersonNameValidatable, :name
    it_behaves_like "a length validator", Test::PersonNameValidatable, :name, too_long_name

    describe "#validate_each" do
      context "when the email is not valid" do
        context "because the email contains invalid characters" do
          validatable = Test::PersonNameValidatable.new(invalid_name)
          error_message = Helpers::Translator.error_message(validatable, :name, :invalid)

          it_behaves_like "an invalid record", validatable, :name, error_message
        end
      end
    end
  end
end