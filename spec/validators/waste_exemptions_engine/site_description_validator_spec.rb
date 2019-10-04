# frozen_string_literal: true

require "rails_helper"

module Test
  SiteDescriptionValidatable = Struct.new(:description) do
    include ActiveModel::Validations

    validates :description, "waste_exemptions_engine/site_description": true
  end
end

module WasteExemptionsEngine
  RSpec.describe SiteDescriptionValidator, type: :model do
    valid_description = "The waste is stored in an out-building next to the barn."
    too_long_description = Helpers::TextGenerator.random_string(501) # The max length is 500.

    it_behaves_like "a validator", Test::SiteDescriptionValidatable, :description, valid_description
    it_behaves_like "a presence validator", Test::SiteDescriptionValidatable, :description
    it_behaves_like "a length validator", Test::SiteDescriptionValidatable, :description, too_long_description
  end
end
