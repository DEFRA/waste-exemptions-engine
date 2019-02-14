# frozen_string_literal: true

require "rails_helper"

module Test
  SiteDescriptionValidatable = Struct.new(:site_description) do
    include ActiveModel::Validations

    validates :site_description, "waste_exemptions_engine/site_description": true
  end
end

module WasteExemptionsEngine
  RSpec.describe SiteDescriptionValidator, type: :model do
    valid_description = "The waste is stored in an out-building next to the barn."
    too_long_description = "Abcdefghij" * 50 + "k" # The max length is 500 and this is 501.

    it_behaves_like "a validator", Test::SiteDescriptionValidatable, :site_description, valid_description
    it_behaves_like "a presence validator", Test::SiteDescriptionValidatable, :site_description
    it_behaves_like "a length validator", Test::SiteDescriptionValidatable, :site_description, too_long_description
  end
end
