# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Lookup Email Forms" do
    let(:registration) { create(:registration, :with_active_exemptions) }
    let(:capture_email_form) { build(:capture_email_form) }
    let(:contact_email) { Faker::Internet.email }

    it_behaves_like "GET form", :capture_email_form, "/enter-an-email-address-that-was-used-during-registration/"
    describe "POST capture_email_form" do
      let(:request_path) { "/waste_exemptions_engine/#{capture_email_form.token}/enter-an-email-address-that-was-used-during-registration" }
      let(:request_body) { { capture_email_form: { reference: registration.reference, contact_email: contact_email } } }

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
