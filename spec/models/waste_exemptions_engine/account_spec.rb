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

    describe "#successful_payments" do
      let(:account) { create(:account) }
      let(:successful_payments_scope) { instance_double(ActiveRecord::Relation) }

      it "calls successful_payments on the payments association" do
        allow(account.payments).to receive(:successful_payments).and_return(successful_payments_scope)
        account.successful_payments

        expect(account.payments).to have_received(:successful_payments)
      end

      it "returns the successful_payments scope" do
        allow(account.payments).to receive(:successful_payments).and_return(successful_payments_scope)

        expect(account.successful_payments).to eq(successful_payments_scope)
      end
    end

    describe "#refunds_and_reversals" do
      let(:account) { create(:account) }
      let(:refunds_scope) { instance_double(ActiveRecord::Relation) }

      it "calls refunds_and_reversals on the payments association" do
        allow(account.payments).to receive(:refunds_and_reversals).and_return(refunds_scope)
        account.refunds_and_reversals

        expect(account.payments).to have_received(:refunds_and_reversals)
      end

      it "returns the refunds_and_reversals scope" do
        allow(account.payments).to receive(:refunds_and_reversals).and_return(refunds_scope)

        expect(account.refunds_and_reversals).to eq(refunds_scope)
      end
    end

    describe "#sorted_orders" do
      let(:account) { create(:account) }
      let!(:oldest_order) { create(:order, order_owner: account, created_at: 3.days.ago) }
      let!(:newest_order) { create(:order, order_owner: account, created_at: 1.day.ago) }
      let!(:middle_order) { create(:order, order_owner: account, created_at: 2.days.ago) }

      it "returns orders sorted by created_at in descending order" do
        expect(account.sorted_orders).to eq([newest_order, middle_order, oldest_order])
      end
    end
  end
end
