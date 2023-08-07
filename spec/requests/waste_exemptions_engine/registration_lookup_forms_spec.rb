# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Lookup Forms" do
    let(:registration) { create(:registration, :with_active_exemptions) }
    let(:registration_lookup_form) { build(:registration_lookup_form) }

    include_examples "GET form", :registration_lookup_form, "/registration-lookup/"
    describe "POST registration_lookup_form" do
      let(:request_path) { "/waste_exemptions_engine/#{registration_lookup_form.token}/registration-lookup" }
      let(:request_body) { { registration_lookup_form: { reference: registration.reference } } }

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
