# frozen_string_literal: true

require "rails_helper"
require "defra_ruby/companies_house"

module WasteExemptionsEngine
  RSpec.describe "Check Registered Name And Address Forms" do
    let(:check_registered_name_and_address_form) { build(:check_registered_name_and_address_form) }
    let(:request_path) { "/waste_exemptions_engine/#{check_registered_name_and_address_form.token}/check-registered-name-and-address" }
    let(:company_status) { :active }
    let(:company_name) { Faker::Company.name }
    let(:company_address) { ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"] }
    let(:companies_house_api) { instance_double(DefraRuby::CompaniesHouse::API) }
    let(:companies_house_api_reponse) do
      {
        company_name:,
        registered_office_address: company_address,
        company_status:
      }
    end
    let(:new_registration) { build(:new_registration, temp_company_no: "12345678") }

    before do
      allow(DefraRuby::CompaniesHouse::API).to receive(:new).and_return(companies_house_api)
      allow(companies_house_api).to receive(:run).and_return(companies_house_api_reponse)
      allow(NewRegistration).to receive(:new).and_return(new_registration)
    end

    include_examples "GET form", :check_registered_name_and_address_form, "/check-registered-name-and-address"
    include_examples "POST form", :check_registered_name_and_address_form, "/check-registered-name-and-address" do
      let(:form_data) { { temp_use_registered_company_details: "true" } }
      let(:invalid_form_data) { [{ temp_use_registered_company_details: "" }] }
    end

    shared_examples "diplays the expected details" do
      it "displays the registered company name" do
        get request_path

        expect(response.body).to have_html_escaped_string(company_name)
      end

      it "displays the registered company address" do
        get request_path

        company_address.each do |line|
          expect(response.body).to include(line)
        end
      end

      it "displays a link to enter a different number" do
        get request_path

        expect(response.body).to have_html_escaped_string(
          I18n.t(".waste_exemptions_engine.check_registered_name_and_address_forms.new.enter_a_different_number")
        )
      end

      context "when the companies house API response does not include an address" do
        let(:company_address) { nil }

        it { expect { get request_path }.not_to raise_error }
      end
    end

    context "with a new registration" do
      let(:new_registration) { build(:new_registration, temp_company_no: "12345678") }

      context "when the company status is active" do
        let(:company_status) { :active }

        it_behaves_like "diplays the expected details"
      end

      context "when the company status is voluntary-arrangement" do
        let(:company_status) { :"voluntary-arrangement" }

        it_behaves_like "diplays the expected details"
      end
    end

    context "with a new charged registration" do
      let(:new_registration) { build(:new_charged_registration, temp_company_no: "12345678") }

      it_behaves_like "diplays the expected details"
    end

    context "when checking registered name and address on Check Your Answers page - new registration" do
      let(:check_registered_name_and_address_form) { build(:check_your_answers_check_registered_name_and_address_form) }

      it "redirects back to check-your-answers when submitted" do
        post "/waste_exemptions_engine/#{check_registered_name_and_address_form.token}/check-registered-name-and-address",
             params: { check_registered_name_and_address_form: { temp_use_registered_company_details: "true" } }

        expect(response).to redirect_to(check_your_answers_forms_path(check_registered_name_and_address_form.token))
      end
    end

    context "with a renewal" do
      let(:renew_check_registered_name_and_address_form) { build(:renew_check_registered_name_and_address_form) }
      let(:renewing_registration) { renew_check_registered_name_and_address_form.transient_registration }
      let(:request_path) { "/waste_exemptions_engine/#{renewing_registration.token}/check-registered-name-and-address" }

      context "when the company status is no longer active" do
        let(:company_status) { :inactive }

        it "displays inactive company error" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("waste_exemptions_engine/check_registered_name_and_address_forms/invalid_or_inactive_company")
            expect(response.body).to have_valid_html
          end
        end
      end

      context "when the company number is invalid" do
        before do
          renewing_registration.temp_company_no = "1"
          renewing_registration.save!
        end

        it "displays the inactive company error" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("waste_exemptions_engine/check_registered_name_and_address_forms/invalid_or_inactive_company")
            expect(response.body).to have_valid_html
          end
        end
      end

      context "when the companies house API is down" do
        before { allow(companies_house_api).to receive(:run).and_raise(StandardError) }

        it "raises an error" do
          get request_path
          expect(response).to render_template("waste_exemptions_engine/shared/companies_house_down")
        end
      end
    end
  end
end
