# frozen_string_literal: true

require "rails_helper"

module Test
  ReusingAddressForSiteAddressValidator = Struct.new(:temp_reuse_address_for_site_location) do
    include ActiveModel::Validations

    validates :temp_reuse_address_for_site_location, "waste_exemptions_engine/reusing_address_for_site_address": true
  end
end

module WasteExemptionsEngine
  RSpec.describe ReusingAddressForSiteAddressValidator, type: :model do
    valid_options = %w[operator_address_option
                       contact_address_option
                       a_different_address].sample

    it_behaves_like "a validator", Test::ReusingAddressForSiteAddressValidator, :temp_reuse_address_for_site_location, valid_options
    it_behaves_like "a selection validator", Test::ReusingAddressForSiteAddressValidator, :temp_reuse_address_for_site_location, valid_options
  end
end
