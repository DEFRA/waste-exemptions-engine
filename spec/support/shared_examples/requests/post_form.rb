# frozen_string_literal: true

RSpec.shared_examples "POST form" do |form_factory, path, empty_form_is_valid = false|
  let(:correct_form) { build(form_factory) }
  let(:post_request_path) { "/waste_exemptions_engine/#{form.token}#{path}" }
  let(:form_data) { { override_me: "Set :form_data in the calling spec." } }
  let(:invalid_form_data) { { override_me: "Set :invalid_form_data in the calling spec." } }

  describe "POST #{form_factory}" do
    context "when the form is not valid", unless: empty_form_is_valid do
      let(:empty_form_request_body) { { form_factory => { token: correct_form.token } } }

      it "renders the same template" do
        post post_request_path, empty_form_request_body
        expect(response).to render_template("waste_exemptions_engine/#{form_factory}s/new")
      end

      it "responds to the POST request with a 200 status code" do
        post post_request_path, empty_form_request_body
        expect(response.code).to eq("200")
      end

      it "includes validation errors for the form data" do
        invalid_form_data.each do |invalid_data|
          post post_request_path, form_factory => invalid_data.merge(token: correct_form.token)

          invalid_form = build(form_factory, **invalid_data)
          invalid_form.validate

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
      let(:request_body) { { form_factory => form_data } }
      let(:modified_token_post_request_path) { "/waste_exemptions_engine/modified-token#{path}" }
      status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE

      it "renders the start form" do
        post modified_token_post_request_path, request_body
        expect(response.location).to include("/waste_exemptions_engine/start")
      end

      it "responds to the POST request with a #{status_code} status code" do
        post modified_token_post_request_path, request_body
        expect(response.code).to eq(status_code.to_s)
      end
    end

    context "when the registration is in the correct state" do
      let(:good_request_body) { { form_factory => form_data.merge(token: correct_form.token) } }
      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      # A successful POST request redirects to the next form in the work flow. We have chosen to
      # differentiate 'good' rediection as 303 and 'bad' redirection as 302.
      # If this test fails for a given form because the status is 200 instead of 303 it is most
      # likely because the form object is not valid.
      it "responds to the POST request with a #{status_code} status code" do
        post post_request_path, good_request_body
        expect(response.code).to eq(status_code.to_s)
      end
    end

    context "when the registration is not in the correct state" do
      # Use a form which cannot be posted and so won't be using this shared example
      let(:incorrect_workflow_state) { :register_in_wales_form }
      let(:incorrect_form) { build(incorrect_workflow_state) }
      let(:transient_registration) { form.transient_registration }
      let(:bad_request_body) { { form_factory => form_data } }
      let(:bad_request_redirection_path) do
        workflow_path = "new_#{incorrect_form.transient_registration.workflow_state}_path".to_sym
        send(workflow_path, token: incorrect_form.transient_registration.token)
      end

      before do
        if transient_registration.is_a?(WasteExemptionsEngine::EditRegistration)
          transient_registration.update_attributes!(workflow_state: :edit_form)
        else
          transient_registration.update_attributes!(workflow_state: :register_in_wales_form)
        end
      end

      status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE

      it "renders the appropriate template" do
        post post_request_path, bad_request_body
        if transient_registration.is_a?(WasteExemptionsEngine::EditRegistration)
          expect(response.location).to include(edit_forms_path(token: form.token))
        else
          expect(response.location).to include(register_in_wales_forms_path(token: form.token))
        end
      end

      it "responds to the POST request with a 302 status code" do
        post post_request_path, bad_request_body
        expect(response.code).to eq(status_code.to_s)
      end

      it "does not update the transient registration workflow state" do
        # Start with a fresh form since incorrect_form could already have an updated workflow state
        trans_reg_id = incorrect_form.transient_registration.id
        expect(WasteExemptionsEngine::TransientRegistration.find(trans_reg_id).workflow_state).to eq(incorrect_workflow_state.to_s)
        post post_request_path, bad_request_body
        expect(WasteExemptionsEngine::TransientRegistration.find(trans_reg_id).workflow_state).to eq(incorrect_workflow_state.to_s)
      end
    end
  end
end
