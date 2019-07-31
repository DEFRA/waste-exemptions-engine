# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renewal Complete Forms", type: :request do
    let(:form) { build(:renewal_complete_form) }

    describe "GET renewal_complete_form" do
      let(:request_path) { "/waste_exemptions_engine/renewal-complete/#{form.token}" }

      it "renders the appropriate template" do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/renewal_complete_forms/new")
      end

      it "responds to the GET request with a 200 status code" do
        get request_path
        expect(response.code).to eq("200")
      end

      it "creates a new registration" do
        initial_count = Registration.count

        get request_path

        expect(Registration.count).to eq(initial_count + 1)
      end

      it "removes the renewing_registration" do
        expect { get request_path }.to change { RenewingRegistration.where(token: form.token).count }.from(1).to(0)
      end

      it "displays the new registration reference number" do
        get request_path
        expect(response.body).to include(Registration.last.reference)
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
