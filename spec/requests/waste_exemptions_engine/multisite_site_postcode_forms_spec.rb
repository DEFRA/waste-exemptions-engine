# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Multisite Site Postcode Forms" do
    before do
      allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
    end

    include_examples "GET form", :multisite_site_postcode_form, "/multisite-site-postcode", is_charged: true
    include_examples "POST form", :multisite_site_postcode_form, "/multisite-site-postcode", is_charged: true do
      let(:form_data) { { temp_site_postcode: "BS1 5AH" } }
      let(:invalid_form_data) { [{ temp_site_postcode: "BS" }, { temp_site_postcode: nil }] }
    end
  end
end
