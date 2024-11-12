# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Account do
    describe "table name" do
      it "uses the correct table name" do
        expect(described_class.table_name).to eq("accounts")
      end
    end

    describe "as order owner" do
      it "can be associated with orders" do
        account = create(:account)
        order = create(:order, order_owner: account)
        expect(account.orders).to include(order)
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
