# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renewal Complete Forms" do
    let(:form) { build(:renewal_complete_form) }

    describe "GET renewal_complete_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/renewal-complete" }

      before do
        # Execute let variable as the factory will generate a registration to renew which should be counted separately
        form
      end

      it "renders the appropriate template", :vcr do
        get request_path

        expect(response).to render_template("waste_exemptions_engine/renewal_complete_forms/new")
      end

      it "returns a 200 status code", :vcr do
        get request_path

        expect(response).to have_http_status(:ok)
      end

      it "creates a new registration", :vcr do
        expect { get request_path }.to change(Registration, :count).by(1)
      end

      it "removes the renewing registration", :vcr do
        expect { get request_path }.to change { RenewingRegistration.where(token: form.token).count }.to(0)
      end

      it "displays the correct reference number", :vcr do
        get request_path

        expect(response.body).to include(Registration.last.reference)
      end

      it "returns W3C valid HTML content", :vcr do
        get request_path

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
