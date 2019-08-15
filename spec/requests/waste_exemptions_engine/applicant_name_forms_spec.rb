# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Applicant Name Forms", type: :request do
    include_examples "GET form", :applicant_name_form, "/applicant-name"
    include_examples "go back", :applicant_name_form, "/applicant-name/back"
    include_examples "POST form", :applicant_name_form, "/applicant-name" do
      let(:form_data) { { first_name: "Joe", last_name: "Bloggs" } }
      let(:invalid_form_data) { [{ first_name: nil, last_name: nil }] }
    end

    context "when editing an existing registration" do
      let(:edit_applicant_name_form) { build(:edit_applicant_name_form) }

      it "prefils applicant name information" do
        get "/waste_exemptions_engine/applicant-name/#{edit_applicant_name_form.token}"

        expect(response.body).to include(edit_applicant_name_form.first_name)
        expect(response.body).to include(edit_applicant_name_form.last_name)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_applicant_name_form) { build(:renew_applicant_name_form) }

      it "prefils applicant name information" do
        get "/waste_exemptions_engine/applicant-name/#{renew_applicant_name_form.token}"

        expect(response.body).to include(renew_applicant_name_form.first_name)
        expect(response.body).to include(renew_applicant_name_form.last_name)
      end
    end
  end
end
