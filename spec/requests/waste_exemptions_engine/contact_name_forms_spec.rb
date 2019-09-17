# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Name Forms", type: :request do
    include_examples "GET form", :contact_name_form, "/contact-name"
    include_examples "go back", :contact_name_form, "/contact-name/back"
    include_examples "POST form", :contact_name_form, "/contact-name" do
      let(:form_data) { { contact_first_name: "Joe", contact_last_name: "Bloggs" } }
      let(:invalid_form_data) { [{ contact_first_name: nil, contact_last_name: nil }] }
    end

    context "when editing an existing registration" do
      let(:edit_contact_name_form) { build(:edit_contact_name_form) }

      it "pre-fills contact name information" do
        get "/waste_exemptions_engine/#{edit_contact_name_form.token}/contact-name"

        expect(response.body).to have_html_escaped_string(edit_contact_name_form.contact_first_name)
        expect(response.body).to have_html_escaped_string(edit_contact_name_form.contact_last_name)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_contact_name_form) { build(:renew_contact_name_form) }

      it "pre-fills contact name information" do
        get "/waste_exemptions_engine/#{renew_contact_name_form.token}/contact-name"

        expect(response.body).to have_html_escaped_string(renew_contact_name_form.contact_first_name)
        expect(response.body).to have_html_escaped_string(renew_contact_name_form.contact_last_name)
      end
    end
  end
end
