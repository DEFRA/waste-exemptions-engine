# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renew", type: :request do
    describe "GET renew/:token" do
      let(:registration) { create(:registration, :complete) }
      let(:request_path) { "/waste_exemptions_engine/renew/#{token}" }

      context "with a valid renew token" do
        let(:token) { registration.renew_token }

        it "redirects to the start renewal page, creates a new RenewingRegistration and returns a 303 status code" do
          expected_count = RenewingRegistration.count + 1

          get request_path

          expect(response.code).to eq("303")

          follow_redirect!

          expect(response).to render_template("waste_exemptions_engine/renewal_start_forms/new")
          expect(RenewingRegistration.count).to eq(expected_count)
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

        it "respond with a 200 status, renders the appropriate template and returns W3C valid HTML content", vcr: true do
          get request_path

          expect(response.code).to eq("200")
          expect(response).to render_template("waste_exemptions_engine/renews/already_renewed")
          expect(response.body).to have_valid_html
        end
      end

      context "when a registration is past the renewal window" do
        let(:registration) { create(:registration, :complete, :past_renewal_window) }
        let(:token) { registration.renew_token }

        it "respond with a 200 status, renders the appropriate template and returns W3C valid HTML content", vcr: true do
          get request_path

          expect(response.code).to eq("200")
          expect(response).to render_template("waste_exemptions_engine/renews/past_renewal_window")
          expect(response.body).to have_valid_html
        end
      end

      context "when a token is invalid" do
        let(:token) { "FooBarBaz" }

        it "returns a 404 status, renders the correct template and returns W3C valid HTML content", vcr: true do
          get request_path

          expect(response.code).to eq("404")
          expect(response).to render_template("waste_exemptions_engine/renews/invalid_magic_link")
          expect(response.body).to have_valid_html
        end
      end
    end
  end
end
