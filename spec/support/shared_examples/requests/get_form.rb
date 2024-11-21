# frozen_string_literal: true

RSpec.shared_examples "GET form" do |form_factory, path|
  let(:correct_form) { build(form_factory) }

  describe "GET #{form_factory}" do
    context "when the registration is in the correct state" do
      let(:good_request_path) { "/waste_exemptions_engine/#{correct_form.token}#{path}" }

      it "renders the appropriate template" do
        get good_request_path

        expect(response).to render_template("waste_exemptions_engine/#{form_factory}s/new")
      end

      it "returns a 200 status" do
        get good_request_path

        expect(response).to have_http_status(:ok)
      end

      it "returns valid HTML content", :ignore_hidden_autocomplete do
        get good_request_path

        expect(response.body).to have_valid_html
      end
    end

    context "when the registration is not in the correct state" do
      let(:bad_request_path) { "/waste_exemptions_engine/#{incorrect_form.token}#{path}" }

      flexible_navigation_allowed = Helpers::WorkflowStates.can_navigate_flexibly_to_state?(form_factory)

      context "when the form can navigate flexibly", if: flexible_navigation_allowed do
        let!(:incorrect_workflow_state) { Helpers::WorkflowStates.previous_state(correct_form.transient_registration) }
        let(:incorrect_form) do
          # curently some states are only available for charged registrations.
          # This is a temporary solution until we release the new registration flow.
          charged_registration_states = [:waste_activities_form]
          build(incorrect_workflow_state, charged_registration_states.include?(form_factory) ? :charged : nil)
        end

        it "renders the appropriate template" do
          get bad_request_path

          expect(response).to render_template("waste_exemptions_engine/#{form_factory}s/new")
        end

        it "returns a 200 status" do
          get bad_request_path

          expect(response).to have_http_status(:ok)
        end

        it "updates the transient registration to the correct workflow state" do
          get bad_request_path

          expect(WasteExemptionsEngine::TransientRegistration.find(incorrect_form.transient_registration.id).workflow_state)
            .to eq(form_factory.to_s)
        end
      end

      context "when the form can not navigate flexibly", unless: flexible_navigation_allowed do
        status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE
        let(:incorrect_form) { build(:start_form) }

        it "responds to the GET request with a #{status_code} status code" do
          get bad_request_path
          expect(response.code).to eq(status_code.to_s)
        end
      end
    end
  end
end
