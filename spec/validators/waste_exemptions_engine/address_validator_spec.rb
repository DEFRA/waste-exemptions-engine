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
    valid_address = Struct.new(:uprn).new({ uprn: 123 })

    it_behaves_like "a validator", Test::AddressValidatable, :address, valid_address
  end
end
