# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Site Address Lookup Forms", :vcr do
    before { VCR.insert_cassette("postcode_valid", allow_playback_repeats: true) }
    after { VCR.eject_cassette }

    let(:form) { build(:site_address_lookup_form) }

    it_behaves_like "GET form", :site_address_lookup_form, "/site-address-lookup"
    it_behaves_like "POST form", :site_address_lookup_form, "/site-address-lookup" do
      let(:form_data) { { site_address: { uprn: "340116" } } }
      let(:invalid_form_data) { [{ site_address: { uprn: nil } }] }
    end

    it "redirects to the last sites page after adding a looked-up multisite address" do
      form.transient_registration.update!(is_multisite_registration: true)

      post site_address_lookup_forms_path(token: form.token),
           params: { site_address_lookup_form: { site_address: { uprn: "340116" } } }

      expect(response).to redirect_to(new_sites_form_path(token: form.token, page: "last"))
    end
  end
end
