# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Your Answers Forms", :vcr do
    before do
      WasteExemptionsEngine::Exemption.delete_all
      create_list(:exemption, 5)
      VCR.insert_cassette("company_no_valid", allow_playback_repeats: true)
    end

    after { VCR.eject_cassette }

    describe "GET check_your_answers_form" do
      include_examples "GET form", :check_your_answers_form, "/check-your-answers"
    end

    describe "POST check_your_answers_form" do
      empty_form_is_valid = true
      include_examples "POST form", :check_your_answers_form, "/check-your-answers", empty_form_is_valid do
        let(:form_data) { {} }
        let(:invalid_form_data) { [] }
      end
    end

    RSpec.shared_examples "a valid transition" do |request_path, redirects_to|
      let(:form) { build(:check_your_answers_form) }

      it "redirects to valid form page" do
        get send(request_path, token: form.token)

        expect(response).to redirect_to send(redirects_to, token: form.token)
      end

      it "sets temp_check_your_answers_flow variable to true" do
        get send(request_path, token: form.token)

        expect(form.transient_registration.reload.temp_check_your_answers_flow).to be_truthy
      end

      it "adds check_your_answers_form into the workflow history" do
        get send(request_path, token: form.token)

        expect(form.transient_registration.reload.workflow_history.last).to eq("check_your_answers_form")
      end
    end

    context "when editing data on Check Your Answers" do
      describe "GET /check-your-answers/exemptions" do
        it_behaves_like "a valid transition", :exemptions_check_your_answers_forms_path, :new_exemptions_form_path
      end

      describe "GET /check-your-answers/contact-name" do
        it_behaves_like "a valid transition", :contact_name_check_your_answers_forms_path, :new_contact_name_form_path
      end

      describe "GET /check-your-answers/contact-position" do
        it_behaves_like "a valid transition", :contact_position_check_your_answers_forms_path, :new_contact_position_form_path
      end

      describe "GET /check-your-answers/contact-phone" do
        it_behaves_like "a valid transition", :contact_phone_check_your_answers_forms_path, :new_contact_phone_form_path
      end

      describe "GET /check-your-answers/contact-email" do
        it_behaves_like "a valid transition", :contact_email_check_your_answers_forms_path, :new_contact_email_form_path
      end

      describe "GET /check-your-answers/contact-address" do
        let(:form) { build(:check_your_answers_form) }

        it_behaves_like "a valid transition", :contact_address_check_your_answers_forms_path, :new_contact_postcode_form_path

        it "redirects to contact_address_form" do
          get contact_address_check_your_answers_forms_path(token: form.token)

          expect(response).to redirect_to new_contact_postcode_form_path(form.token)
        end

        it "sets temp_check_your_answers_flow variable to true" do
          get contact_address_check_your_answers_forms_path(token: form.token)

          expect(form.transient_registration.reload.temp_check_your_answers_flow).to be_truthy
        end

        it "adds check_your_answers_form into the workflow history" do
          get contact_address_check_your_answers_forms_path(token: form.token)

          expect(form.transient_registration.reload.workflow_history.last).to eq("check_your_answers_form")
        end
      end

      describe "GET /check-your-answers/operator-name" do
        it_behaves_like "a valid transition", :operator_name_check_your_answers_forms_path, :new_operator_name_form_path
      end

      describe "GET /check-your-answers/on-a-farm" do
        it_behaves_like "a valid transition", :on_a_farm_check_your_answers_forms_path, :new_on_a_farm_form_path
      end

      describe "GET /check-your-answers/is-a-farmer" do
        it_behaves_like "a valid transition", :is_a_farmer_check_your_answers_forms_path, :new_is_a_farmer_form_path
      end
    end
  end
end
