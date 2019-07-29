# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renew", type: :request do
    describe "GET renew/:token" do
      let(:registration) { create(:registration) }
      let(:request_path) { "/waste_exemptions_engine/renew/#{token}" }

      context "with a valid renew token" do
        let(:token) { generate_valid_renew_token(registration) }

        it "renders the appropriate template" do
          get request_path

          expect(response).to render_template("waste_exemptions_engine/renews/new")
        end

        it "creates a new RenewingRegistration" do
          expect { get request_path }.to change { RenewingRegistration.count }.by(1)
        end

        it "responds to the GET request with a 200 status code" do
          get request_path

          expect(response.code).to eq("200")
        end
      end

      context "when a token is expired" do
        let(:token) { generate_expired_renew_token(registration) }

        it "returns a 403 status" do
          get request_path

          expect(response.code).to eq("403")
        end
      end

      context "when a token's payload is missing registration information" do
        let(:token) { generate_invalid_payload_renew_token(registration) }

        it "returns false" do
          get request_path

          expect(response.code).to eq("403")
        end
      end

      context "when a token is not saved agains the correct registration" do
        let(:token) { generate_renew_token_without_updating_registration(registration) }

        it "returns false" do
          get request_path

          expect(response.code).to eq("403")
        end
      end
    end
  end
end
