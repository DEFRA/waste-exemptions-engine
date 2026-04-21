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

    context "when some addresses returned by the postcode lookup are outside England" do
      before do
        allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).and_call_original
        allow(WasteExemptionsEngine::FeatureToggle)
          .to receive(:active?).with(:restrict_site_locations_to_england).and_return(true)
        allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
        allow(WasteExemptionsEngine::CheckSiteLocationIsInEnglandService).to receive(:run)
          .with(grid_reference: nil, easting: "358205.03", northing: "172708.07")
          .and_return(true)
        allow(WasteExemptionsEngine::CheckSiteLocationIsInEnglandService).to receive(:run)
          .with(grid_reference: nil, easting: "358130.1", northing: "172687.87")
          .and_return(false)
      end

      it "shows a notice that only addresses in England are shown" do
        get site_address_lookup_forms_path(token: form.token)

        expect(response.body).to include("Only addresses in England are shown.")
      end
    end
  end
end
