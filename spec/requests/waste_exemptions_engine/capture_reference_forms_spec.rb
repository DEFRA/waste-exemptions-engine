# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Lookup Forms" do
    let(:registration) { create(:registration, :with_active_exemptions) }
    let(:capture_reference_form) { build(:capture_reference_form) }

    include_examples "GET form", :capture_reference_form, "/registration-lookup/"
    describe "POST capture_reference_form" do
      let(:request_path) { "/waste_exemptions_engine/#{capture_reference_form.token}/registration-lookup" }
      let(:request_body) { { capture_reference_form: { reference: registration.reference } } }

      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      # A successful POST request redirects to the next form in the work flow. We have chosen to
      # differentiate 'good' rediection as 303 and 'bad' redirection as 302.
      it "responds to the POST request with a #{status_code} status code" do
        post request_path, params: request_body
        expect(response.code).to eq(status_code.to_s)
      end
    end
  end
end
