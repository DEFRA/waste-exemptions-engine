# frozen_string_literal: true

require "rails_helper"

module Test
  LocationValidatable = Struct.new(:location) do
    include ActiveModel::Validations

    validates :location, "waste_exemptions_engine/location": true
  end
end

module WasteExemptionsEngine
  RSpec.describe LocationValidator, type: :model do
    valid_location = %w[
      england
      northern_ireland
      scotland
      wales
    ].sample

    it_behaves_like "a validator", Test::LocationValidatable, :location, valid_location
    it_behaves_like "a selection validator", Test::LocationValidatable, :location
  end
end
