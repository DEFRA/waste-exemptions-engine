# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Applicant Email Forms", type: :request do
    include_examples "GET form", :applicant_email_form, "/applicant-email"
    include_examples "go back", :applicant_email_form, "/applicant-email/back"
    include_examples "POST form", :applicant_email_form, "/applicant-email" do
      let(:form_data) { { applicant_email: "test@example.com", confirmed_email: "test@example.com" } }
      let(:invalid_form_data) do
        [
          { applicant_email: "foo", confirmed_email: "Bar" },
          { applicant_email: nil, confirmed_email: nil },
          { applicant_email: "test@email.com", confirmed_email: "different-test@email.com" }
        ]
      end
    end

    context "when editing an existing registration" do
      let(:edit_applicant_email_form) { build(:edit_applicant_email_form) }

      it "pre-fills applicant email information" do
        get "/waste_exemptions_engine/applicant-email/#{edit_applicant_email_form.token}"

        expect(response.body).to have_html_escaped_string(edit_applicant_email_form.applicant_email)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_applicant_email_form) { build(:renew_applicant_email_form) }

      it "pre-fills applicant email information" do
        get "/waste_exemptions_engine/applicant-email/#{renew_applicant_email_form.token}"

        expect(response.body).to have_html_escaped_string(renew_applicant_email_form.applicant_email)
      end
    end
  end
end
