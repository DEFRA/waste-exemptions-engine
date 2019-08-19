# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Applicant Phone Forms", type: :request do
    include_examples "GET form", :applicant_phone_form, "/applicant-phone"
    include_examples "go back", :applicant_phone_form, "/applicant-phone/back"
    include_examples "POST form", :applicant_phone_form, "/applicant-phone" do
      let(:form_data) { { phone_number: "01234567890" } }
      let(:invalid_form_data) { [{ phone_number: nil }, { phone_number: "1234" }] }
    end

    context "when editing an existing registration" do
      let(:edit_applicant_phone_form) { build(:edit_applicant_phone_form) }

      it "pre-fills applicant phone information" do
        get "/waste_exemptions_engine/applicant-phone/#{edit_applicant_phone_form.token}"

        expect(response.body).to have_html_escaped_string(edit_applicant_phone_form.phone_number)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_applicant_phone_form) { build(:renew_applicant_phone_form) }

      it "pre-fills applicant phone information" do
        get "/waste_exemptions_engine/applicant-phone/#{renew_applicant_phone_form.token}"

        expect(response.body).to have_html_escaped_string(renew_applicant_phone_form.phone_number)
      end
    end
  end
end
