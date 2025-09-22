# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Email Forms" do
    it_behaves_like "GET form", :contact_email_form, "/contact-email"
    it_behaves_like "POST form", :contact_email_form, "/contact-email" do
      let(:form_data) { { contact_email: "test@example.com", confirmed_email: "test@example.com" } }
      let(:invalid_form_data) do
        [
          { contact_email: "test@example.com", confirmed_email: "test_different@example.com" },
          { contact_email: "invalid", confirmed_email: "invalid" },
          { contact_email: nil, confirmed_email: nil }
        ]
      end
    end

    context "when editing contact email on Check Your Answers page - new registration" do
      let(:contact_email_form) { build(:check_your_answers_edit_contact_email_form) }

      it "pre-fills contact email information" do
        get "/waste_exemptions_engine/#{contact_email_form.token}/contact-email"

        expect(response.body).to have_html_escaped_string(contact_email_form.contact_email)
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{contact_email_form.token}/contact-email",
             params: { contact_email_form: { contact_email: "test@example.com", confirmed_email: "test@example.com" } }

        expect(response).to redirect_to(check_your_answers_forms_path(contact_email_form.token))
      end
    end

    context "when editing an existing registration" do
      let(:edit_contact_email_form) { build(:edit_contact_email_form) }

      it "pre-fills contact email information" do
        get "/waste_exemptions_engine/#{edit_contact_email_form.token}/contact-email"

        expect(response.body).to have_html_escaped_string(edit_contact_email_form.contact_email)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_contact_email_form) { build(:renew_contact_email_form) }

      it "pre-fills contact email information" do
        get "/waste_exemptions_engine/#{renew_contact_email_form.token}/contact-email"

        expect(response.body).to have_html_escaped_string(renew_contact_email_form.contact_email)
      end
    end

    context "when editing contact email on Renewals Start page - renew registration" do
      let(:contact_email_form) { build(:renewal_start_edit_contact_email_form) }

      it "pre-fills contact email information" do
        get "/waste_exemptions_engine/#{contact_email_form.token}/contact-email"

        expect(response.body).to have_html_escaped_string(contact_email_form.contact_email)
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{contact_email_form.token}/contact-email",
             params: { contact_email_form: { contact_email: "test@example.com", confirmed_email: "test@example.com" } }

        expect(response).to redirect_to(renewal_start_forms_path(contact_email_form.token))
      end
    end
  end
end
