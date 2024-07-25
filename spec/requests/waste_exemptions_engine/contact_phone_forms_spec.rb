# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Phone Forms" do
    include_examples "GET form", :contact_phone_form, "/contact-phone"
    include_examples "POST form", :contact_phone_form, "/contact-phone" do
      let(:form_data) { { contact_phone: "01234567890" } }
      let(:invalid_form_data) { [{ contact_phone: "123" }, { contact_phone: nil }] }
    end

    context "when editing contact phone on Check Your Answers page - new registration" do
      let(:contact_phone_form) { build(:check_your_answers_edit_contact_phone_form) }

      it "pre-fills contact phone information" do
        get "/waste_exemptions_engine/#{contact_phone_form.token}/contact-phone"

        expect(response.body).to have_html_escaped_string(contact_phone_form.contact_phone)
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{contact_phone_form.token}/contact-phone",
             params: { contact_phone_form: { contact_phone: "01234567890" } }

        expect(response).to redirect_to(check_your_answers_forms_path(contact_phone_form.token))
      end
    end

    context "when editing an existing registration" do
      let(:edit_contact_phone_form) { build(:edit_contact_phone_form) }

      it "pre-fills contact phone information" do
        get "/waste_exemptions_engine/#{edit_contact_phone_form.token}/contact-phone"

        expect(response.body).to have_html_escaped_string(edit_contact_phone_form.contact_phone)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_contact_phone_form) { build(:renew_contact_phone_form) }

      it "pre-fills contact phone information" do
        get "/waste_exemptions_engine/#{renew_contact_phone_form.token}/contact-phone"

        expect(response.body).to have_html_escaped_string(renew_contact_phone_form.contact_phone)
      end
    end

    context "when editing contact phone on Renewals Start page - renew registration" do
      let(:contact_phone_form) { build(:renewal_start_edit_contact_phone_form) }

      it "pre-fills contact position information" do
        get "/waste_exemptions_engine/#{contact_phone_form.token}/contact-phone"

        expect(response.body).to have_html_escaped_string(contact_phone_form.contact_phone)
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{contact_phone_form.token}/contact-phone",
             params: { contact_phone: { contact_phone: "0123456789" } }

        expect(response).to redirect_to(renewal_start_forms_path(contact_phone_form.token))
      end
    end
  end
end
