# frozen_string_literal: true

require "rails_helper"

module Test
  ManualAddressValidatable = Struct.new(:premises, :street_address, :locality, :city, :postcode) do
    include ActiveModel::Validations

    validates_with WasteExemptionsEngine::ManualAddressValidator
  end
end

module WasteExemptionsEngine
  RSpec.describe ManualAddressValidator, type: :model do
    valid_premises = "Example House"
    too_long_premises = Helpers::TextGenerator.random_string(201) # The max length is 200.
    valid_street_address = "2 On The Road"
    too_long_street_address = Helpers::TextGenerator.random_string(161) # The max length is 160.
    valid_locality = "Near Horizon House"
    too_long_locality = Helpers::TextGenerator.random_string(71) # The max length is 70.
    valid_city = "Bristol"
    too_long_city = Helpers::TextGenerator.random_string(31) # The max length is 30.
    valid_postcode = "BS1 5AH"
    too_long_postcode = Helpers::TextGenerator.random_string(9) # The max length is 8.

    valid_parameters = [
      valid_premises, valid_street_address, valid_locality, valid_city, valid_postcode
    ]
    too_long_parameters = [
      too_long_premises, too_long_street_address, too_long_locality, too_long_city, too_long_postcode
    ]

    required_attributes = %i[premises street_address city]
    optional_attributes = %i[locality postcode]
    ordered_attributes = %i[premises street_address locality city postcode]
    length_validated_attributes = ordered_attributes

    # Map all combinations of the 5 attributes where 4 are valid and one is either missing or too long.
    # The attributes have to be in an array in the same order as the ManualAddressValidatable params.
    inputs = ordered_attributes.each_with_index.each_with_object({}) do |(attribute, i), h|
      h[attribute] = {
        missing: valid_parameters.each_with_index.map { |p, j| i == j ? "" : p },
        too_long: valid_parameters.each_with_index.map { |p, j| i == j ? too_long_parameters[i] : p }
      }
    end

    describe "#validate" do
      context "when the manual address is valid" do
        it_behaves_like "a valid record", Test::ManualAddressValidatable.new(*valid_parameters)

        optional_attributes.each do |property|
          context "even though the #{property} is missing (because it is optional" do
            it_behaves_like "a valid record", Test::ManualAddressValidatable.new(*(inputs[property][:missing]))
          end
        end
      end

      context "when the manual address is not valid" do
        context "and the form is empty" do
          subject(:validatable) { Test::ManualAddressValidatable.new }
          it "confirms the object is invalid" do
            expect(validatable).to_not be_valid
          end

          it "adds as many validation errors to the record as there are required fields" do
            validatable.valid?
            expect(validatable.errors.count).to eq(required_attributes.count)
          end
        end

        context "and every attribute is too long" do
          subject(:validatable) do
            Test::ManualAddressValidatable.new(
              too_long_premises,
              too_long_street_address,
              too_long_locality,
              too_long_city,
              too_long_postcode
            )
          end

          it "confirms the object is invalid" do
            expect(validatable).to_not be_valid
          end

          it "adds as many validation errors to the record as there are length validated fields" do
            validatable.valid?
            expect(validatable.errors.count).to eq(length_validated_attributes.count)
          end
        end

        required_attributes.each do |property|
          context "because the #{property} is missing" do
            validatable = Test::ManualAddressValidatable.new(*(inputs[property][:missing]))
            error_message = Helpers::Translator.error_message(validatable, property, :blank)

            it_behaves_like "an invalid record", validatable, property, error_message
          end
        end

        length_validated_attributes.each do |property|
          context "because the #{property} is too long" do
            validatable = Test::ManualAddressValidatable.new(*(inputs[property][:too_long]))
            error_message = Helpers::Translator.error_message(validatable, property, :too_long)

            it_behaves_like "an invalid record", validatable, property, error_message
          end
        end
      end
    end
  end
end
