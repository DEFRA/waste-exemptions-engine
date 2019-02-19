# frozen_string_literal: true

require "rails_helper"

module Test
  GridReferenceValidatable = Struct.new(:grid_reference) do
    include ActiveModel::Validations

    validates :grid_reference, "waste_exemptions_engine/grid_reference": true
  end
end

module WasteExemptionsEngine
  RSpec.describe GridReferenceValidator, type: :model do
    valid_grid_reference = "ST 58337 72855" # Bristol, City of Bristol
    invalid_grid_reference = "58337 72855"
    non_coordinate_grid_reference = "AA 12345 67890"

    it_behaves_like "a validator", Test::GridReferenceValidatable, :grid_reference, valid_grid_reference
    it_behaves_like "a presence validator", Test::GridReferenceValidatable, :grid_reference

    describe "#validate_each" do
      context "when the grid reference is not valid" do
        context "because the grid reference is not correctly formatted" do
          validatable = Test::GridReferenceValidatable.new(invalid_grid_reference)
          error_message = Helpers::Translator.error_message(validatable, :grid_reference, :wrong_format)

          it_behaves_like "an invalid record", validatable, :grid_reference, error_message
        end

        context "because the grid reference is not a coordinate" do
          validatable = Test::GridReferenceValidatable.new(non_coordinate_grid_reference)
          error_message = Helpers::Translator.error_message(validatable, :grid_reference, :invalid)

          it_behaves_like "an invalid record", validatable, :grid_reference, error_message
        end
      end
    end
  end
end
