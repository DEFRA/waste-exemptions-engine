# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renewal Start Forms" do
    let(:form) { build(:renewal_start_form) }

    # Happy path: The addresses are present.
    before do
      form.transient_registration.update(
        operator_address: build(:transient_address, :operator_address),
        contact_address: build(:transient_address, :contact_address)
      )
    end

    describe "GET renewal_start_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/renewal-start" }

      it "renders the appropriate template", :vcr do
        get request_path

        expect(response).to render_template("waste_exemptions_engine/renewal_start_forms/new")
      end

      it "returns a 200 status code", :vcr do
        get request_path

        expect(response).to have_http_status(:ok)
      end

      it "returns W3C valid HTML content", :vcr, :ignore_hidden_autocomplete do
        get request_path

        expect(response.body).to have_valid_html
      end

      # There is an edge case where a lot of back-and-forth navigation and
      # changing the postcode can result in an address being nil.
      shared_examples "redirects to the address form" do |address_type|
        let(:token) { form.transient_registration.token }
        let(:request_path) { new_renewal_start_form_path(token) }
        let(:expected_redirect) { send("new_#{address_type}_postcode_form_path", token:) }

        it { expect { get request_path }.not_to raise_error }

        it "redirects to the correct form" do
          get request_path

          expect(response).to redirect_to(expected_redirect)
        end
      end

      context "when the operator address is not present" do
        before { form.transient_registration.update(operator_address: nil) }

        it_behaves_like "redirects to the address form", :operator
      end

      context "when the contact address is not present" do
        before { form.transient_registration.update(contact_address: nil) }

        it_behaves_like "redirects to the address form", :contact
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/renewal-complete/back" }

      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    empty_form_is_valid = true
    it_behaves_like "POST form", :renewal_start_form, "/renewal-start", empty_form_is_valid do
      let(:form_data) { {} }
      let(:invalid_form_data) { [] }
    end

    context "when editing data on Check Your Answers" do
      let(:form_name) { "renewal_start_form" }

      describe "GET /renewal-start/exemptions" do
        it_behaves_like "a valid transition", :exemptions_renewal_start_forms_path, :new_exemptions_form_path
      end

      describe "GET /renewal-start/applicant-name" do
        it_behaves_like "a valid transition", :applicant_name_renewal_start_forms_path, :new_applicant_name_form_path
      end

      describe "GET /renewal-start/applicant-phone" do
        it_behaves_like "a valid transition", :applicant_phone_renewal_start_forms_path, :new_applicant_phone_form_path
      end

      describe "GET /renewal-start/applicant-email" do
        it_behaves_like "a valid transition", :applicant_email_renewal_start_forms_path, :new_applicant_email_form_path
      end

      describe "GET /renewal-start/on-a-farm" do
        it_behaves_like "a valid transition", :on_a_farm_renewal_start_forms_path, :new_on_a_farm_form_path
      end

      describe "GET /renewal-start/is-a-farmer" do
        it_behaves_like "a valid transition", :is_a_farmer_renewal_start_forms_path, :new_is_a_farmer_form_path
      end

      describe "GET /renewal-start/contact-address" do
        it_behaves_like "a valid transition", :contact_address_renewal_start_forms_path, :new_contact_postcode_form_path
      end

      describe "GET /renewal-start/contact-position" do
        it_behaves_like "a valid transition", :contact_position_renewal_start_forms_path, :new_contact_position_form_path
      end

      describe "GET /renewal-start/contact-name" do
        it_behaves_like "a valid transition", :contact_name_renewal_start_forms_path, :new_contact_name_form_path
      end

      describe "GET /renewal-start/contact-phone" do
        it_behaves_like "a valid transition", :contact_phone_renewal_start_forms_path, :new_contact_phone_form_path
      end

      describe "GET /renewal-start/operator-address" do
        it_behaves_like "a valid transition", :operator_address_renewal_start_forms_path, :new_operator_postcode_form_path
      end

      describe "GET /renewal-start/contact-email" do
        it_behaves_like "a valid transition", :contact_email_renewal_start_forms_path, :new_contact_email_form_path
      end
    end

    context "when trying to access not-existing or deleted registration" do
      let(:request_path) { "/waste_exemptions_engine/not-existing-registration-token/renewal-start" }

      it "redirects to start page" do
        get request_path

        aggregate_failures do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(%r{/waste_exemptions_engine/start})
        end
      end
    end
  end
end
