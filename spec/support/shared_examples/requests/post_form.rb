# frozen_string_literal: true

RSpec.shared_examples "POST form" do |form_factory, path, empty_form_is_valid = false|
  let(:correct_form) { build(form_factory) }
  let(:post_request_path) { "/waste_exemptions_engine/#{correct_form.token}#{path}" }
  let(:form_data) { { override_me: "Set :form_data in the calling spec." } }
  let(:invalid_form_data) { { override_me: "Set :invalid_form_data in the calling spec." } }

  describe "POST #{form_factory}" do
    context "when the form is not valid", unless: empty_form_is_valid do
      context "when the form is empty" do
        it "renders the same template" do
          post post_request_path

          expect(response).to render_template("waste_exemptions_engine/#{form_factory}s/new")
        end

        it "returns a 200 status code" do
          post post_request_path

          expect(response).to have_http_status(:ok)
        end
      end

      it "includes validation errors for the form data" do
        invalid_form_data.each do |invalid_data|
          post post_request_path, params: { form_factory => invalid_data }

          invalid_form = build(form_factory)
          invalid_form.submit(ActionController::Parameters.new(invalid_data).permit!)

          raise("No errors found for invalid data: #{invalid_data}") if invalid_form.valid?

          invalid_form.errors.messages.values.flatten.each do |error_message|
            # We include error messages twice, but RSpec has no built-in "include twice" method yet.
            # Hence, the scan will make sure we match the message *at least* twice in the rendered page.
            expect(response.body.scan(error_message).count).to be > 1
          end
        end
      end
    end

    context "when the token has been modified" do
      subject(:post_request) { post "/waste_exemptions_engine/modified-token#{path}", params: request_body }

      let(:request_body) { { form_factory => form_data } }

      status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE

      it "renders the start form" do
        post_request

        expect(response.location).to include("/waste_exemptions_engine/start")
      end

      it "returns a #{status_code} status code" do
        post_request

        expect(response.code).to eq(status_code.to_s)
      end
    end

    context "when the registration is in the correct state" do
      let(:good_request_body) { { form_factory => form_data } }

      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      # A successful POST request redirects to the next form in the work flow. We have chosen to
      # differentiate 'good' rediection as 303 and 'bad' redirection as 302.
      # If this test fails for a given form because the status is 200 instead of 303 it is most
      # likely because the form object is not valid.
      it "responds to the POST request with a #{status_code} status code" do
        post post_request_path, params: good_request_body
        expect(response.code).to eq(status_code.to_s)
      end
    end

    context "when the registration is not in the correct state" do
      subject(:post_request) { post post_request_path, params: { form_factory => form_data } }

      # Use a form which cannot be posted and so won't be using this shared example
      let(:incorrect_workflow_state) { :register_in_wales_form }
      let(:incorrect_form) { build(incorrect_workflow_state) }
      let(:transient_registration) { correct_form.transient_registration }

      before do
        case transient_registration.class.name
        when "WasteExemptionsEngine::BackOfficeEditRegistration"
          transient_registration.update!(workflow_state: :back_office_edit_form)
        when "WasteExemptionsEngine::FrontOfficeEditRegistration"
          transient_registration.update!(workflow_state: :front_office_edit_form)
        when "WasteExemptionsEngine::RenewingRegistration"
          transient_registration.update!(workflow_state: :applicant_name_form)
        else
          transient_registration.update!(workflow_state: :register_in_wales_form)
        end
      end

      status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE

      it "renders the appropriate template" do
        post_request

        case transient_registration.class.name
        when "WasteExemptionsEngine::BackOfficeEditRegistration"
          expect(response.location).to include(back_office_edit_forms_path(token: correct_form.token))
        when "WasteExemptionsEngine::FrontOfficeEditRegistration"
          expect(response.location).to include(front_office_edit_forms_path(token: correct_form.token))
        when "WasteExemptionsEngine::RenewingRegistration"
          expect(response.location).to include(applicant_name_forms_path(token: correct_form.token))
        else
          expect(response.location).to include(register_in_wales_forms_path(token: correct_form.token))
        end
      end

      it "returns a 302" do
        post_request

        expect(response.code).to eq(status_code.to_s)
      end

      it "does not update the transient registration workflow state" do
        trans_reg_id = incorrect_form.transient_registration.id

        post_request

        expect(WasteExemptionsEngine::TransientRegistration.find(trans_reg_id).workflow_state)
          .to eq(incorrect_workflow_state.to_s)
      end
    end
  end
end
