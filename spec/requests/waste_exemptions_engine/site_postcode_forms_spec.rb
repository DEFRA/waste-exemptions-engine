# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Site Postcode Forms" do
    it_behaves_like "GET form", :site_postcode_form, "/site-postcode"
    it_behaves_like "POST form", :site_postcode_form, "/site-postcode" do
      let(:form_data) { { temp_site_postcode: "BS1 5AH" } }
      let(:invalid_form_data) { [{ temp_site_postcode: "BS" }, { temp_site_postcode: nil }] }
    end

    context "when editing an existing registration" do
      let(:edit_site_postcode_form) { build(:edit_site_postcode_form) }

      it "pre-fills site postcode information" do
        get "/waste_exemptions_engine/#{edit_site_postcode_form.token}/site-postcode"

        expect(response.body).to have_html_escaped_string(edit_site_postcode_form.temp_site_postcode)
      end
    end

    context "when the England-only restriction is enabled" do
      let(:form) { build(:site_postcode_form) }
      let(:response) do
        instance_double(
          DefraRuby::Address::Response,
          successful?: true,
          results: [{ "x" => "358205.03", "y" => "172708.07" }],
          error: nil
        )
      end

      before do
        allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).and_call_original
        allow(WasteExemptionsEngine::FeatureToggle)
          .to receive(:active?).with(:restrict_site_locations_to_england).and_return(true)
        allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
        allow(WasteExemptionsEngine::AddressLookupService).to receive(:run).with("BS1 5AH").and_return(response)
        allow(WasteExemptionsEngine::CheckSiteLocationIsInEnglandService).to receive(:run).and_return(false)
      end

      it "re-renders the postcode page with an England-only error" do
        post site_postcode_forms_path(token: form.token), params: { site_postcode_form: { temp_site_postcode: "BS1 5AH" } }

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("We cannot find an address in England for that postcode.")
        end
      end
    end
  end
end
