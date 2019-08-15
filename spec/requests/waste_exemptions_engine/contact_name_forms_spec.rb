# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Name Forms", type: :request do
    include_examples "GET form", :contact_name_form, "/contact-name"
    include_examples "go back", :contact_name_form, "/contact-name/back"
    include_examples "POST form", :contact_name_form, "/contact-name" do
      let(:form_data) { { first_name: "Joe", last_name: "Bloggs" } }
      let(:invalid_form_data) { [{ first_name: nil, last_name: nil }] }
    end

    context "when editing an existing registration" do
      let(:edit_contact_name_form) { build(:edit_contact_name_form) }

      it "prefils contact name information" do
        get "/waste_exemptions_engine/contact-name/#{edit_contact_name_form.token}"

        expect(response.body).to include(edit_contact_name_form.first_name)
        expect(response.body).to include(edit_contact_name_form.last_name)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_contact_name_form) { build(:renew_contact_name_form) }

      it "prefils contact name information" do
        get "/waste_exemptions_engine/contact-name/#{renew_contact_name_form.token}"

        expect(response.body).to include(renew_contact_name_form.first_name)
        expect(response.body).to include(renew_contact_name_form.last_name)
      end
    end
  end
end
