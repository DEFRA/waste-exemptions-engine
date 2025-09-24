# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Multisite Site Address Lookup Forms", :vcr do
    before do
      VCR.insert_cassette("postcode_valid", allow_playback_repeats: true)
      allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
    end

    after { VCR.eject_cassette }

    it_behaves_like "GET form", :multisite_site_address_lookup_form, "/multisite-site-address-lookup", is_charged: true
    it_behaves_like "POST form", :multisite_site_address_lookup_form, "/multisite-site-address-lookup", is_charged: true do
      let(:form_data) { { site_address: { uprn: "340116" } } }
      let(:invalid_form_data) { [{ site_address: { uprn: nil } }] }
    end
  end
end
