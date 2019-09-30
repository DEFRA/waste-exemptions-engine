# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Position Forms", type: :request do
    include_examples "GET form", :contact_position_form, "/contact-position"
    include_examples "go back", :contact_position_form, "/contact-position/back"

    empty_form_is_valid = true
    include_examples "POST form", :contact_position_form, "/contact-position", empty_form_is_valid do
      let(:form_data) { { contact_position: "Chief Waste Carrier" } }
      let(:invalid_form_data) { [] }
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
  end
end
