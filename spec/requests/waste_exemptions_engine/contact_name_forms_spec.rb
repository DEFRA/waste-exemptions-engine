# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Name Forms" do
    include_examples "GET form", :contact_name_form, "/contact-name"
    include_examples "POST form", :contact_name_form, "/contact-name" do
      let(:form_data) { { contact_first_name: "Joe", contact_last_name: "Bloggs" } }
      let(:invalid_form_data) { [{ contact_first_name: nil, contact_last_name: nil }] }
    end

    context "when editing contact name on Check Your Answers page - new registration" do
      let(:contact_name_form) { build(:check_your_answers_edit_contact_name_form) }

      it "pre-fills contact name information" do
        get "/waste_exemptions_engine/#{contact_name_form.token}/contact-name"

        aggregate_failures do
          expect(response.body).to have_html_escaped_string(contact_name_form.contact_first_name)
          expect(response.body).to have_html_escaped_string(contact_name_form.contact_last_name)
        end
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{contact_name_form.token}/contact-name",
             params: { contact_name_form: { contact_first_name: "Joe", contact_last_name: "Bloggs" } }

        expect(response).to redirect_to(check_your_answers_forms_path(contact_name_form.token))
      end
    end

    context "when editing an existing registration" do
      let(:edit_contact_name_form) { build(:edit_contact_name_form) }

      it "pre-fills contact name information" do
        get "/waste_exemptions_engine/#{edit_contact_name_form.token}/contact-name"

        aggregate_failures do
          expect(response.body).to have_html_escaped_string(edit_contact_name_form.contact_first_name)
          expect(response.body).to have_html_escaped_string(edit_contact_name_form.contact_last_name)
        end
      end
    end

    context "when renewing an existing registration" do
      let(:renew_contact_name_form) { build(:renew_contact_name_form) }

      it "pre-fills contact name information" do
        get "/waste_exemptions_engine/#{renew_contact_name_form.token}/contact-name"

        aggregate_failures do
          expect(response.body).to have_html_escaped_string(renew_contact_name_form.contact_first_name)
          expect(response.body).to have_html_escaped_string(renew_contact_name_form.contact_last_name)
        end
      end
    end

    context "when editing contact name on Renewals Start page - renew registration" do
      let(:contact_name_form) { build(:renewal_start_edit_contact_name_form) }

      it "pre-fills contact name information" do
        get "/waste_exemptions_engine/#{contact_name_form.token}/contact-name"

        aggregate_failures do
          expect(response.body).to have_html_escaped_string(contact_name_form.contact_first_name)
          expect(response.body).to have_html_escaped_string(contact_name_form.contact_last_name)
        end
      end

      it "redirects back to renewals-start when submitted" do
        post "/waste_exemptions_engine/#{contact_name_form.token}/contact-name",
             params: { contact_name_form: { contact_first_name: "Joe", contact_last_name: "Bloggs" } }

        expect(response).to redirect_to(renewal_start_forms_path(contact_name_form.token))
      end
    end
  end
end
