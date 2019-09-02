# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Postcode Forms", type: :request do
    include_examples "GET form", :contact_postcode_form, "/contact-postcode"
    include_examples "go back", :contact_postcode_form, "/contact-postcode/back"
    include_examples "POST form", :contact_postcode_form, "/contact-postcode" do
      let(:form_data) { { temp_contact_postcode: "BS1 5AH" } }
      let(:invalid_form_data) { [{ temp_contact_postcode: "BA" }, { temp_contact_postcode: nil }] }
    end

    include_examples "skip to manual address",
                     :contact_postcode_form,
                     request_path: "/contact-postcode/skip_to_manual_address",
                     result_path: "/contact-address-manual"

    context "when editing an existing registration" do
      let(:edit_contact_postcode_form) { build(:edit_contact_postcode_form) }

      it "pre-fills contact postcode information" do
        get "/waste_exemptions_engine/contact-postcode/#{edit_contact_postcode_form.token}"

        expect(response.body).to have_html_escaped_string(edit_contact_postcode_form.temp_contact_postcode)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_contact_postcode_form) { build(:renew_contact_postcode_form) }

      it "pre-fills contact postcode information" do
        get "/waste_exemptions_engine/contact-postcode/#{renew_contact_postcode_form.token}"

        expect(response.body).to have_html_escaped_string(renew_contact_postcode_form.temp_contact_postcode)
      end
    end
  end
end
