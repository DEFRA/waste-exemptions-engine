# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Multisite Site Address Lookup Forms", :vcr do
    before { VCR.insert_cassette("postcode_valid", allow_playback_repeats: true) }
    after { VCR.eject_cassette }

    include_examples "GET form", :multisite_site_address_lookup_form, "/multisite-site-address-lookup", is_charged: true
    include_examples "POST form", :multisite_site_address_lookup_form, "/multisite-site-address-lookup", is_charged: true do
      let(:form_data) { { site_address: { uprn: "340116" } } }
      let(:invalid_form_data) { [{ site_address: { uprn: nil } }] }
    end
  end
end
