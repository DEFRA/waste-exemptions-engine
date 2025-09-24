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
  end
end
