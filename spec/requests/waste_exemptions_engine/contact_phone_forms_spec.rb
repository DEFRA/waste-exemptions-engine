# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Phone Forms", type: :request do
    include_examples "GET form", :contact_phone_form, "/contact-phone"
    include_examples "go back", :contact_phone_form, "/contact-phone/back"
    include_examples "POST form", :contact_phone_form, "/contact-phone" do
      let(:form_data) { { phone_number: "01234567890" } }
      let(:invalid_form_data) { [{ phone_number: "123" }, { phone_number: nil }] }
    end

    context "when editing an existing registration" do
      let(:edit_contact_phone_form) { build(:edit_contact_phone_form) }

      it "pre-fills contact phone information" do
        get "/waste_exemptions_engine/contact-phone/#{edit_contact_phone_form.token}"

        expect(response.body).to have_html_escaped_string(edit_contact_phone_form.phone_number)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_contact_phone_form) { build(:renew_contact_phone_form) }

      it "pre-fills contact phone information" do
        get "/waste_exemptions_engine/contact-phone/#{renew_contact_phone_form.token}"

        expect(response.body).to have_html_escaped_string(renew_contact_phone_form.phone_number)
      end
    end
  end
end
