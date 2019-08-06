# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renew", type: :request do
    describe "GET renew/:token" do
      let(:registration) { create(:registration, :complete) }
      let(:request_path) { "/waste_exemptions_engine/renew/#{token}" }

      context "with a valid renew token" do
        let(:token) { registration.renew_token }

        it "redirects to the start renewal page" do
          get request_path
          follow_redirect!

          expect(response).to render_template("waste_exemptions_engine/renewal_start_forms/new")
        end

        it "creates a new RenewingRegistration" do
          expect { get request_path }.to change { RenewingRegistration.count }.by(1)
        end

        it "responds to the GET request with a 303 status code" do
          get request_path

          expect(response.code).to eq("303")
        end

        context "when a renewal was left in progress" do
          it "redirects to the correct flow state page" do
            # Request the page once so we generate a valid renewing registration
            get request_path

            # Update the workflow of the transient registration
            renewing_registration = RenewingRegistration.last
            renewing_registration.update workflow_state: "location_form"

            get request_path
            follow_redirect!

            expect(response).to render_template("waste_exemptions_engine/location_forms/new")
          end
        end
      end

      context "when a token has already been used" do
        let(:token) { registration.renew_token }

        before do
          create(:registration, referring_registration_id: registration.id)
        end

        it "respond with a 200 status" do
          get request_path

          expect(response.code).to eq("200")
        end

        it "renders the appropriate template" do
          get request_path

          expect(response).to render_template("waste_exemptions_engine/renews/already_renewed")
        end

        it "returns W3C valid HTML content", vcr: true do
          get request_path

          expect(response.body).to have_valid_html
        end
      end

      context "when a token is invalid" do
        let(:token) { "FooBarBaz" }

        it "returns a 302 status" do
          get request_path

          expect(response.code).to eq("302")
        end

        it "returns a 403 page error template" do
          get request_path
          follow_redirect!

          expect(response.code).to render_template("waste_exemptions_engine/errors/error_404")
        end
      end
    end
  end
end
