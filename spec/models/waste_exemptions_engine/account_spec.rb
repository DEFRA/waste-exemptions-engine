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
  end
end
