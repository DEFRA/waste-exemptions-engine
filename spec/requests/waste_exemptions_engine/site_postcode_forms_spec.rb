# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Site Postcode Forms", type: :request do
    include_examples "GET form", :site_postcode_form, "/site-postcode"
    include_examples "go back", :site_postcode_form, "/site-postcode/back"
    include_examples "POST form", :site_postcode_form, "/site-postcode" do
      let(:form_data) { { postcode: "BS1 5AH" } }
      let(:invalid_form_data) { [{ postcode: "BS" }, { postcode: nil }] }
    end

    include_examples "skip to manual address",
                     :site_postcode_form,
                     request_path: "/site-postcode/skip_to_manual_address",
                     result_path: "/site-address-manual"

    context "when editing an existing registration" do
      let(:edit_site_postcode_form) { build(:edit_site_postcode_form) }

      it "prefils site grid reference information" do
        get "/waste_exemptions_engine/site-postcode/#{edit_site_postcode_form.token}"

        expect(response.body).to include(edit_site_postcode_form.postcode)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_site_postcode_form) { build(:renew_site_postcode_form) }

      it "prefils site grid reference information" do
        get "/waste_exemptions_engine/site-postcode/#{renew_site_postcode_form.token}"

        expect(response.body).to include(renew_site_postcode_form.postcode)
      end
    end
  end
end
