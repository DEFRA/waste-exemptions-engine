# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe AccountBalanceService do
    let(:account) { create(:account) }

    describe ".run" do
      let(:order_one) { create(:order, :with_charge_detail, order_owner: account) }
      let(:order_two) { create(:order, :with_charge_detail, order_owner: account) }
      let(:payment_one) { create(:payment, account: account, payment_amount: order_one.total_charge_amount, payment_status: Payment::PAYMENT_STATUS_SUCCESS) }
      let(:payment_two) { create(:payment, account: account, payment_amount: order_two.total_charge_amount, payment_status: Payment::PAYMENT_STATUS_SUCCESS) }

      before do
        order_one
        order_two
        payment_one
        payment_two
      end

      context "when orders total matches payments total" do
        let(:expected_balance) { 0 }

        it "calculates the correct account balance" do
          balance = described_class.run(account)
          expect(balance).to eq(expected_balance)
        end
      end

      context "when orders total does not match payments total" do
        context "when some payments are failed" do
          let(:expected_balance) { 0 - order_two.total_charge_amount }

          before do
            payment_two.update(payment_status: Payment::PAYMENT_STATUS_FAILED)
          end

          it "calculates the correct account balance with failed payments" do
            balance = described_class.run(account)
            expect(balance).to eq(expected_balance)
          end
        end

        context "when there are no successfull payments" do
          let(:expected_balance) { 0 - order_one.total_charge_amount - order_two.total_charge_amount }

          before do
            payment_one.destroy
            payment_two.destroy
          end

          it "calculates the correct account balance with no payments" do
            balance = described_class.run(account)
            expect(balance).to eq(expected_balance)
          end
        end

        context "when there are no orders" do
          let(:expected_balance) { payment_one.payment_amount + payment_two.payment_amount }

          before do
            order_one.destroy
            order_two.destroy
          end

          it "calculates the correct account balance with no orders" do
            balance = described_class.run(account)
            expect(balance).to eq(expected_balance)
          end
        end
      end
    end
  end
end
