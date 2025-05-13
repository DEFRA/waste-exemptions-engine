# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Position Forms" do
    include_examples "GET form", :contact_position_form, "/contact-position"

    empty_form_is_valid = true
    include_examples "POST form", :contact_position_form, "/contact-position", empty_form_is_valid do
      let(:form_data) { { contact_position: "Chief Waste Carrier" } }
      let(:invalid_form_data) { [] }
    end

    context "when editing contact position on Check Your Answers page - new registration" do
      let(:contact_position_form) { build(:check_your_answers_edit_contact_position_form) }

      it "pre-fills contact position information" do
        get "/waste_exemptions_engine/#{contact_position_form.token}/contact-position"

        expect(response.body).to have_html_escaped_string(contact_position_form.contact_position)
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{contact_position_form.token}/contact-position",
             params: { contact_position_form: { contact_position: "Manager" } }

        expect(response).to redirect_to(check_your_answers_forms_path(contact_position_form.token))
      end
    end

    context "when editing an existing registration" do
      let(:edit_contact_position_form) { build(:edit_contact_position_form) }

      it "pre-fills contact position information" do
        get "/waste_exemptions_engine/#{edit_contact_position_form.token}/contact-position"

        expect(response.body).to have_html_escaped_string(edit_contact_position_form.contact_position)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_contact_position_form) { build(:renew_contact_position_form) }

      it "pre-fills contact position information" do
        get "/waste_exemptions_engine/#{renew_contact_position_form.token}/contact-position"

        expect(response.body).to have_html_escaped_string(renew_contact_position_form.contact_position)
      end
    end

    context "when editing contact position on Renewals Start page - renew registration" do
      let(:contact_position_form) { build(:renewal_start_edit_contact_position_form) }

      it "pre-fills contact position information" do
        get "/waste_exemptions_engine/#{contact_position_form.token}/contact-position"

        expect(response.body).to have_html_escaped_string(contact_position_form.contact_position)
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{contact_position_form.token}/contact-position",
             params: { contact_position: { contact_position: "foo" } }

        expect(response).to redirect_to(renewal_start_forms_path(contact_position_form.token))
      end
    end
  end
end
