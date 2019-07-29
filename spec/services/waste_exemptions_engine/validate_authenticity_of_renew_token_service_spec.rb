# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ValidateAuthenticityOfRenewTokenService do
    describe ".run" do
      let(:registration) { create(:registration) }
      let(:result) { WasteExemptionsEngine::ValidateAuthenticityOfRenewTokenService.run(token: token) }

      context "when a token is valid" do
        let(:token) { generate_valid_renew_token(registration) }

        it "returns true" do
          expect(result).to be_truthy
        end
      end

      context "when a token is expired" do
        let(:token) { generate_expired_renew_token(registration) }

        it "returns false" do
          expect(result).to be_falsey
        end
      end

      context "when a token's payload is missing registration information" do
        let(:token) { generate_invalid_payload_renew_token(registration) }

        it "returns false" do
          expect(result).to be_falsey
        end
      end

      context "when a token is not saved agains the correct registration" do
        let(:token) { generate_renew_token_without_updating_registration(registration) }

        it "returns false" do
          expect(result).to be_falsey
        end
      end
    end
  end
end
