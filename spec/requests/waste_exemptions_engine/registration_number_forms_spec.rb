# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Number Forms", :vcr do
    before { VCR.insert_cassette("company_no_valid", allow_playback_repeats: true) }
    after { VCR.eject_cassette }

    include_examples "GET form", :registration_number_form, "/registration-number"
    include_examples "POST form", :registration_number_form, "/registration-number" do
      let(:form_data) { { company_no: "09360070" } }
      let(:invalid_form_data) { [{ company_no: nil }] }
    end

    context "when editing registration number on Check Your Answers page - new registration" do
      let(:registration_number_form) { build(:check_your_answers_edit_registration_number_form) }

      it "pre-fills registration number information" do
        get "/waste_exemptions_engine/#{registration_number_form.token}/registration-number"

        expect(response.body).to have_html_escaped_string(registration_number_form.company_no)
      end

      it "redirects to check-registered-name-and-address when submitted" do
        post "/waste_exemptions_engine/#{registration_number_form.token}/registration-number",
             params: { registration_number_form: { company_no: "09360070" } }

        expect(response).to redirect_to(check_registered_name_and_address_forms_path(registration_number_form.token))
      end
    end
  end
end
