# frozen_string_literal: true

RSpec.shared_examples "go back" do |form_factory, path|
  let(:form) { build(form_factory) }
  let(:previous_workflow_state) { Helpers::WorkflowStates.previous_state(form.transient_registration) }
  let(:back_request_path) { "/waste_exemptions_engine/#{form.token}#{path}" }
  let(:redirection_path) { send("new_#{previous_workflow_state}_path".to_sym, token: form.transient_registration.token) }
  status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

  describe "GET #{form_factory} back" do
    it "renders the appropriate template and returns a #{status_code} status code" do
      get back_request_path
      expect(response.location).to include(redirection_path)
      expect(response.code).to eq(status_code.to_s)
    end
  end
end
