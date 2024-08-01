# frozen_string_literal: true

require "rails_helper"

module Test
  PaymentTypeValidateable = Struct.new(:payment_type) do
    include ActiveModel::Validations

    validates :payment_type, "waste_exemptions_engine/payment_type": true
  end
end

module WasteExemptionsEngine
  RSpec.describe PaymentTypeValidator, type: :model do
    valid_type = %w[card bank_transfer].sample

    it_behaves_like "a validator", Test::PaymentTypeValidateable, :payment_type, valid_type
    it_behaves_like "a selection validator", Test::PaymentTypeValidateable, :payment_type
  end
end
