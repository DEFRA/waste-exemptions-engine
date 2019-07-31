# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe GenerateRenewTokenService do
    describe ".run" do
      let(:registration) { create(:registration) }

      it "generates a new renewal token and assigns it to a registration" do
        expect { WasteExemptionsEngine::GenerateRenewTokenService.run(registration: registration) }.to change { registration.reload.renew_token.present? }.to(true)
      end
    end
  end
end
