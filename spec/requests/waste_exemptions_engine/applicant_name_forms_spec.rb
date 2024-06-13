# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Applicant Name Forms" do
    include_examples "GET form", :applicant_name_form, "/applicant-name"
    include_examples "POST form", :applicant_name_form, "/applicant-name" do
      let(:form_data) { { applicant_first_name: "Joe", applicant_last_name: "Bloggs" } }
      let(:invalid_form_data) { [{ applicant_first_name: nil, applicant_last_name: nil }] }
    end

    context "when editing applicant name on Check Your Answers page - new registration" do
      let(:applicant_name_form) { build(:check_your_answers_edit_applicant_name_form) }

      it "pre-fills applicant name information" do
        get "/waste_exemptions_engine/#{applicant_name_form.token}/applicant-name"

        aggregate_failures do
          expect(response.body).to have_html_escaped_string(applicant_name_form.applicant_first_name)
          expect(response.body).to have_html_escaped_string(applicant_name_form.applicant_last_name)
        end
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{applicant_name_form.token}/applicant-name",
             params: { applicant_name_form: { applicant_first_name: "Joe", applicant_last_name: "Bloggs" } }

        expect(response).to redirect_to(check_your_answers_forms_path(applicant_name_form.token))
      end
    end

    context "when editing an existing registration" do
      let(:edit_applicant_name_form) { build(:edit_applicant_name_form) }

      it "pre-fills applicant name information" do
        get "/waste_exemptions_engine/#{edit_applicant_name_form.token}/applicant-name"

        aggregate_failures do
          expect(response.body).to have_html_escaped_string(edit_applicant_name_form.applicant_first_name)
          expect(response.body).to have_html_escaped_string(edit_applicant_name_form.applicant_last_name)
        end
      end
    end

    context "when renewing an existing registration" do
      let(:renew_applicant_name_form) { build(:renew_applicant_name_form) }

      it "pre-fills applicant name information" do
        get "/waste_exemptions_engine/#{renew_applicant_name_form.token}/applicant-name"

        aggregate_failures do
          expect(response.body).to have_html_escaped_string(renew_applicant_name_form.applicant_first_name)
          expect(response.body).to have_html_escaped_string(renew_applicant_name_form.applicant_last_name)
        end
      end
    end
  end
end
