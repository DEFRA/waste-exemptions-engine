# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Applicant Phone Forms" do
    it_behaves_like "GET form", :applicant_phone_form, "/applicant-phone"
    it_behaves_like "POST form", :applicant_phone_form, "/applicant-phone" do
      let(:form_data) { { applicant_phone: "01234567890" } }
      let(:invalid_form_data) { [{ applicant_phone: nil }, { applicant_phone: "1234" }] }
    end

    context "when editing applicant phone on Check Your Answers page - new registration" do
      let(:applicant_phone_form) { build(:check_your_answers_edit_applicant_phone_form) }

      it "pre-fills applicant phone information" do
        get "/waste_exemptions_engine/#{applicant_phone_form.token}/applicant-phone"

        expect(response.body).to have_html_escaped_string(applicant_phone_form.applicant_phone)
      end

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{applicant_phone_form.token}/applicant-phone",
             params: { applicant_phone_form: { applicant_phone: "01234567890" } }

        expect(response).to redirect_to(check_your_answers_forms_path(applicant_phone_form.token))
      end
    end

    context "when editing applicant phone on Renewal Start page - renew registration" do
      let(:applicant_phone_form) { build(:renewal_start_edit_applicant_phone_form) }

      it "pre-fills applicant phone information" do
        get "/waste_exemptions_engine/#{applicant_phone_form.token}/applicant-phone"

        expect(response.body).to have_html_escaped_string(applicant_phone_form.applicant_phone)
      end

      it "redirects back to Renewal Start when submitted" do
        post "/waste_exemptions_engine/#{applicant_phone_form.token}/applicant-phone",
             params: { applicant_phone_form: { applicant_phone: "01234567890" } }

        expect(response).to redirect_to(renewal_start_forms_path(applicant_phone_form.token))
      end
    end

    context "when editing an existing registration" do
      let(:edit_applicant_phone_form) { build(:edit_applicant_phone_form) }

      it "pre-fills applicant phone information" do
        get "/waste_exemptions_engine/#{edit_applicant_phone_form.token}/applicant-phone"

        expect(response.body).to have_html_escaped_string(edit_applicant_phone_form.applicant_phone)
      end
    end

    context "when renewing an existing registration" do
      let(:renew_applicant_phone_form) { build(:renew_applicant_phone_form) }

      it "pre-fills applicant phone information" do
        get "/waste_exemptions_engine/#{renew_applicant_phone_form.token}/applicant-phone"

        expect(response.body).to have_html_escaped_string(renew_applicant_phone_form.applicant_phone)
      end
    end
  end
end
