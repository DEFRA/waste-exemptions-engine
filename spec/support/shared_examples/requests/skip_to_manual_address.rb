# frozen_string_literal: true

RSpec.shared_examples "skip to manual address" do |form_factory, request_path:, result_path:|
  let(:form) { build(form_factory) }
  let(:manual_address_request_path) { "/waste_exemptions_engine#{request_path}/#{form.token}" }
  let(:manual_address_form_path) { "/waste_exemptions_engine#{result_path}/#{form.token}" }
  status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

  describe "GET #{form_factory} skip to manual address" do
    it "renders the appropriate template" do
      get manual_address_request_path
      expect(response.location).to include(manual_address_form_path)
    end

    it "responds to the GET request with a #{status_code} status code" do
      get manual_address_request_path
      expect(response.code).to eq(status_code.to_s)
    end
  end
end
