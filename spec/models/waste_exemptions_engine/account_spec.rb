# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Account do
    describe "#update_balance" do
      let(:account) { create(:account) }
      let(:orders) { [] }
      let(:payments) { [] }

      before do
        orders.each { |order| account.orders << order }
        payments.each { |payment| account.payments << payment }
      end

      context "when there are no orders or payments" do
        it "sets balance to zero" do
          account.update_balance
          expect(account.balance).to eq(0)
        end
      end

      context "when there are orders but no payments" do
        let(:orders) { [create(:order, :with_charge_detail)] }

        it "sets balance to sum of order amounts" do
          account.update_balance
          expect(account.balance).to be > 0
        end
      end

      context "when there are payments but no orders" do
        let(:payments) do
          [
            create(:payment, payment_amount: 75),
            create(:payment, payment_amount: 25)
          ]
        end

        it "sets balance to negative sum of payment amounts" do
          account.update_balance
          expect(account.balance).to be < 0
        end
      end

      context "when there are both orders and payments" do
        let(:orders) { [create(:order, :with_charge_detail)] }
        let(:payments) do
          [
            create(:payment, payment_amount: 150),
            create(:payment, payment_amount: 50)
          ]
        end

        it "sets balance to difference between orders and payments" do
          account.update_balance
          expect(account.balance).to eq(orders.sum(&:total_charge_amount) - payments.sum(&:payment_amount))
        end
      end
    end

    describe "#overpaid?" do
      let(:account) { create(:account) }

      context "when balance is positive" do
        before { account.balance = 100 }

        it "returns false" do
          expect(account.overpaid?).to be false
        end
      end

      context "when balance is zero" do
        before { account.balance = 0 }

        it "returns false" do
          expect(account.overpaid?).to be false
        end
      end

      context "when balance is negative" do
        before { account.balance = -50 }

        it "returns true" do
          expect(account.overpaid?).to be true
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
  end
end
