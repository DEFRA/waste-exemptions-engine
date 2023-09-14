# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renewal Complete Forms" do
    let(:form) { build(:renewal_complete_form) }

    describe "GET renewal_complete_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/renewal-complete" }

      it "renders the appropriate template, returns a 200 status code, creates a new registration, removes the renewing registration, display the correct reference number and returns W3C valid HTML content", :vcr do
        # Execute let variable as the factory will generate a registration to renew which should be counted separately
        form

        initial_count = Registration.count
        expect(RenewingRegistration.where(token: form.token).count).to eq(1)

        get request_path

        expect(response).to render_template("waste_exemptions_engine/renewal_complete_forms/new")
        expect(response).to have_http_status(:ok)
        expect(Registration.count).to eq(initial_count + 1)
        expect(RenewingRegistration.where(token: form.token).count).to eq(0)
        expect(response.body).to include(Registration.last.reference)
        expect(response.body).to have_valid_html
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "/waste_exemptions_engine/renewal-complete/back/#{form.token}" }

      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    include_examples "unable to POST form", :renewal_complete_form, "/renewal-complete"
  end
end
