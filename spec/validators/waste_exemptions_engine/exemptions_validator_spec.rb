# frozen_string_literal: true

require "rails_helper"

module Test
  ExemptionsValidatable = Struct.new(:exemptions) do
    include ActiveModel::Validations

    validates :exemptions, "waste_exemptions_engine/exemptions": true
  end
end

module WasteExemptionsEngine
  RSpec.describe ExemptionsValidator, type: :model do
    valid_exemptions = %w[3 17]

    # Since valid_exemptions is an Array we need to wrap it in another Array to avoid treating
    # the argument like a set of multiple arguments.
    it_behaves_like "a validator", Test::ExemptionsValidatable, :exemptions, [valid_exemptions]

    describe "#validate_each" do
      context "when the exemptions selection is not valid" do
        context "when the exemptions are not present" do
          validatable = Test::ExemptionsValidatable.new
          error_message = Helpers::Translator.error_message(validatable, :exemptions, :inclusion)

          it_behaves_like "an invalid record", validatable, :exemptions, error_message
        end

        context "when the exemptions are empty" do
          validatable = Test::ExemptionsValidatable.new([])
          error_message = Helpers::Translator.error_message(validatable, :exemptions, :inclusion)

          it_behaves_like "an invalid record", validatable, :exemptions, error_message
        end
      end
    end
  end
end
