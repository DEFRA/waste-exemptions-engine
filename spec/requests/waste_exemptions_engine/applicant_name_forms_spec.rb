# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Applicant Name Forms", type: :request do
    include_examples "GET form", :applicant_name_form, "/applicant-name"
    include_examples "go back", :applicant_name_form, "/applicant-name/back"
    include_examples "POST form", :applicant_name_form, "/applicant-name" do
      let(:form_data) { { applicant_first_name: "Joe", applicant_last_name: "Bloggs" } }
      let(:invalid_form_data) { [{ applicant_first_name: nil, applicant_last_name: nil }] }
    end

    context "when editing an existing registration" do
      let(:edit_applicant_name_form) { build(:edit_applicant_name_form) }

      it "pre-fills applicant name information" do
        get "/waste_exemptions_engine/applicant-name/#{edit_applicant_name_form.token}"

        expect(response.body).to have_html_escaped_string(edit_applicant_name_form.applicant_first_name)
        expect(response.body).to have_html_escaped_string(edit_applicant_name_form.applicant_last_name)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_applicant_name_form) { build(:renew_applicant_name_form) }

      it "pre-fills applicant name information" do
        get "/waste_exemptions_engine/applicant-name/#{renew_applicant_name_form.token}"

        expect(response.body).to have_html_escaped_string(renew_applicant_name_form.applicant_first_name)
        expect(response.body).to have_html_escaped_string(renew_applicant_name_form.applicant_last_name)
      end
    end
  end
end
