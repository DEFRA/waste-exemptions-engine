# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Site Address Lookup Forms", :vcr do
    before { VCR.insert_cassette("postcode_valid", allow_playback_repeats: true) }
    after { VCR.eject_cassette }

    include_examples "GET form", :site_address_lookup_form, "/site-address-lookup"
    include_examples "POST form", :site_address_lookup_form, "/site-address-lookup" do
      let(:form_data) { { site_address: { uprn: "340116" } } }
      let(:invalid_form_data) { [{ site_address: { uprn: nil } }] }
    end
  end
end
