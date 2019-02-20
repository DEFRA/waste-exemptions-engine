# frozen_string_literal: true

require "rails_helper"

module Test
  PersonValidatable = Struct.new(:first_name, :last_name) do
    include ActiveModel::Validations

    validates_with WasteExemptionsEngine::PersonValidator, validate_fields: true
  end
end

module WasteExemptionsEngine
  RSpec.describe PersonValidator, type: :model do
    valid_first_name = "Joe"
    valid_last_name = "Bloggs"
    too_long_name = Helpers::TextGenerator.random_string(36) # The max length is 35.

    inputs = {
      first_name: { missing: ["", valid_last_name], too_long: [too_long_name, valid_last_name] },
      last_name: { missing: [valid_first_name, ""], too_long: [valid_first_name, too_long_name] }
    }

    describe "#validate" do
      context "when the person is valid" do
        it_behaves_like "a valid record", Test::PersonValidatable.new(valid_first_name, valid_last_name)
      end

      context "when the person is not valid" do
        %i[first_name last_name].each do |property|
          context "because the #{property} is missing" do
            validatable = Test::PersonValidatable.new(*(inputs[property][:missing]))
            error_message = Helpers::Translator.error_message(validatable, property, :blank)

            it_behaves_like "an invalid record", validatable, property, error_message
          end

          context "because the #{property} is too long" do
            validatable = Test::PersonValidatable.new(*(inputs[property][:too_long]))
            error_message = Helpers::Translator.error_message(validatable, property, :too_long)

            it_behaves_like "an invalid record", validatable, property, error_message
          end
        end
      end
    end
  end
end
