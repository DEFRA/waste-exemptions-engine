# frozen_string_literal: true

RSpec.shared_examples "GET form" do |form_factory, path|
  let(:correct_form) { build(form_factory) }
  let!(:incorrect_workflow_state) { Helpers::WorkflowStates.previous_state(correct_form.transient_registration) }
  let(:incorrect_form) { build(incorrect_workflow_state) }

  describe "GET #{form_factory}" do
    context "when the registration is in the correct state" do
      let(:good_request_path) { "/waste_exemptions_engine#{path}/#{correct_form.token}" }

      it "renders the appropriate template" do
        get good_request_path
        expect(response).to render_template("waste_exemptions_engine/#{form_factory}s/new")
      end

      it "responds to the GET request with a 200 status code" do
        get good_request_path
        expect(response.code).to eq("200")
      end
    end

    context "when the registration is not in the correct state" do
      let(:bad_request_path) { "/waste_exemptions_engine#{path}/#{incorrect_form.token}" }

      flexible_navigation_allowed = Helpers::WorkflowStates.can_navigate_flexibly_to_state?(form_factory)

      context "and the form can navigate flexibly", if: flexible_navigation_allowed do
        it "renders the appropriate template" do
          get bad_request_path
          expect(response).to render_template("waste_exemptions_engine/#{form_factory}s/new")
        end

        it "responds to the GET request with a 200 status code" do
          get bad_request_path
          expect(response.code).to eq("200")
        end

        it "updates the transient registration to the correct workflow state" do
          # Start with a fresh form since incorrect_form could already have an updated workflow state
          form = build(incorrect_workflow_state)
          trans_reg_id = form.transient_registration.id
          expect(WasteExemptionsEngine::TransientRegistration.find(trans_reg_id).workflow_state).to eq(incorrect_workflow_state.to_s)
          get "/waste_exemptions_engine#{path}/#{form.token}"
          expect(WasteExemptionsEngine::TransientRegistration.find(trans_reg_id).workflow_state).to eq(form_factory.to_s)
        end
      end

      context "and the form can not navigate flexibly", unless: flexible_navigation_allowed do
        status_code = WasteExemptionsEngine::ApplicationController::UNSUCCESSFUL_REDIRECTION_CODE

        it "responds to the GET request with a #{status_code} status code" do
          get bad_request_path
          expect(response.code).to eq(status_code.to_s)
        end
      end
    end
  end
end
