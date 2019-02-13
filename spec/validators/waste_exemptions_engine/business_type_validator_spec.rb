# frozen_string_literal: true

require "rails_helper"

module Test
  BusinessTypeValidatable = Struct.new(:business_type) do
    include ActiveModel::Validations

    validates :business_type, "waste_exemptions_engine/business_type": true
  end
end

module WasteExemptionsEngine
  RSpec.describe BusinessTypeValidator, type: :model do
    valid_type = %w[
      charity
      limitedCompany
      limitedLiabilityPartnership
      localAuthority
      partnership
      soleTrader
    ].sample

    it_behaves_like "a validator", Test::BusinessTypeValidatable, :business_type, valid_type

    describe "#validate_each" do
      context "when the business type is not valid" do
        context "because the business type is not present" do
          validatable = Test::BusinessTypeValidatable.new
          error_message = Helpers::Translator.error_message(validatable, :business_type, :inclusion)

          it_behaves_like "an invalid record", validatable, :business_type, error_message
        end

        context "because the business type is not from an approved list" do
          validatable = Test::BusinessTypeValidatable.new("unexpectedType")
          error_message = Helpers::Translator.error_message(validatable, :business_type, :inclusion)

          it_behaves_like "an invalid record", validatable, :business_type, error_message
        end
      end
    end
  end
end
