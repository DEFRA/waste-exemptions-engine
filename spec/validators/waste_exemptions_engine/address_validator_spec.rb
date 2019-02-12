# frozen_string_literal: true

require "rails_helper"

module Test
  AddressValidatable = Struct.new(:address) do
    include ActiveModel::Validations

    validates :address, "waste_exemptions_engine/address": true
  end
end

module WasteExemptionsEngine
  RSpec.describe AddressValidator, type: :model do
    valid_address = "Temple Quay House, 2 The Square, Temple Quay, Bristol"

    it_behaves_like "a validator", AddressValidator, Test::AddressValidatable, :address, valid_address
    it_behaves_like "a presence validator", Test::AddressValidatable, :address
  end
end
