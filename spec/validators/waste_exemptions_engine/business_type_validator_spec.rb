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
    valid_type = TransientRegistration::BUSINESS_TYPES.values.sample

    it_behaves_like "a validator", Test::BusinessTypeValidatable, :business_type, valid_type
    it_behaves_like "a selection validator", Test::BusinessTypeValidatable, :business_type
  end
end
