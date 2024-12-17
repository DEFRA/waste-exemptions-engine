# frozen_string_literal: true

require "rails_helper"
require "defra_ruby_companies_house"

module WasteExemptionsEngine
  RSpec.describe "Registration Number Forms", :vcr do
    let(:companies_house_service) { instance_double(DefraRubyCompaniesHouse) }
    let(:request_path) { "/waste_exemptions_engine/#{registration_number_form.token}/registration-number" }
    let(:companies_house_type) { "ltd" }
    let(:companies_house_response) { JSON.parse(File.read("spec/fixtures/files/companies_house_response.json")) }

    before do
      companies_house_response["type"] = companies_house_type
      stub_request(:get, /#{Rails.configuration.companies_house_host}[a-zA-Z\d]{8}/).to_return(
        status: 200,
        body: companies_house_response.to_json
      )
    end

    include_examples "GET form", :registration_number_form, "/registration-number"
    include_examples "POST form", :registration_number_form, "/registration-number" do
      let(:form_data) { { temp_company_no: "09360070" } }
      let(:invalid_form_data) { [{ temp_company_no: nil }] }
    end

    context "with a new registration" do
      let(:registration_number_form) { build(:registration_number_form) }
      let(:valid_params) { { registration_number_form: { temp_company_no: "09360070" } } }
      let(:unsupported_company_type_message) { I18n.t("defra_ruby.validators.CompaniesHouseNumberValidator.unsupported_company_type") }

      before { post request_path, params: valid_params }

      shared_examples "does not report unsupported company type" do
        it { expect(response.body).not_to include unsupported_company_type_message }
      end

      context "with ltd company type" do
        let(:companies_house_type) { "ltd" }

        it_behaves_like "does not report unsupported company type"
      end

      context "with llp company type" do
        let(:companies_house_type) { "llp" }

        it_behaves_like "does not report unsupported company type"
      end

      context "with plc company type" do
        let(:companies_house_type) { "plc" }

        it_behaves_like "does not report unsupported company type"
      end
    end

    context "when editing registration number on Check Your Answers page - new registration" do
      let(:registration_number_form) { build(:check_your_answers_edit_registration_number_form) }

      it "pre-fills registration number information" do
        get "/waste_exemptions_engine/#{registration_number_form.token}/registration-number"

        expect(response.body).to have_html_escaped_string(registration_number_form.temp_company_no)
      end

      it "redirects to check-registered-name-and-address when submitted" do
        post "/waste_exemptions_engine/#{registration_number_form.token}/registration-number",
             params: { registration_number_form: { temp_company_no: "09360070" } }

        expect(response).to redirect_to(check_registered_name_and_address_forms_path(registration_number_form.token))
      end
    end

    context "when a back-office edit is in progress and the Companies House API call fails" do
      let(:registration_number_form) { build(:back_office_edit_registration_number_form) }
      let(:companies_house_instance) { instance_double(DefraRubyCompaniesHouse) }

      before do
        allow(DefraRubyCompaniesHouse).to receive(:new).and_return(companies_house_instance)
        allow(companies_house_instance).to receive(:load_company).and_raise(StandardError)
        allow(companies_house_instance).to receive(:company_name).and_raise(StandardError)
      end

      it "redirects to the companies house down page" do
        post "/waste_exemptions_engine/#{registration_number_form.token}/registration-number",
             params: { registration_number_form: { temp_company_no: "09360070" } }

        expect(response).to render_template("waste_exemptions_engine/shared/companies_house_down")
      end
    end
  end
end
