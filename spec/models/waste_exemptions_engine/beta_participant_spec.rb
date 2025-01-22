# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BetaParticipant do
    describe "#generate_token" do
      let(:beta_participant) { build(:beta_participant, token: nil) }

      it "generate the token" do
        expect { beta_participant.generate_token }.to change(beta_participant, :token)
      end
    end

    describe "callbacks" do
      let(:beta_participant) { described_class.new(reg_number: "123", email: "test@example.com") }

      it "calls generate_token before create" do
        allow(beta_participant).to receive(:generate_token)
        beta_participant.save!
        expect(beta_participant).to have_received(:generate_token)
      end
    end
  end
end
