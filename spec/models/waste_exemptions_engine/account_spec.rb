# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Account do
    describe "#overpaid?" do
      let(:account) { create(:account) }

      context "when balance is positive" do
        before { allow(account).to receive(:balance).and_return(50) }

        it "returns true" do
          expect(account.overpaid?).to be true
        end
      end

      context "when balance is zero" do
        before { allow(account).to receive(:balance).and_return(0) }

        it "returns false" do
          expect(account.overpaid?).to be false
        end
      end

      context "when balance is negative" do
        before { allow(account).to receive(:balance).and_return(-50) }

        it "returns false" do
          expect(account.overpaid?).to be false
        end
      end
    end

    describe "#balance" do
      let(:account) { create(:account) }
      let(:balance) { 100 }

      it "calls the AccountBalanceService and returns the balance" do
        allow(AccountBalanceService).to receive(:run).with(account).and_return(balance)

        aggregate_failures "testing the balance" do
          expect(account.balance).to eq(balance)
          expect(AccountBalanceService).to have_received(:run).with(account)
        end
      end
    end

    describe "#site_count" do
      let(:registration) { create(:registration) }
      let(:account) { create(:account, registration: registration) }

      it "delegates to registration.site_count" do
        allow(registration).to receive(:site_count).and_return(3)
        
        expect(account.site_count).to eq(3)
        expect(registration).to have_received(:site_count)
      end
    end
  end
end
