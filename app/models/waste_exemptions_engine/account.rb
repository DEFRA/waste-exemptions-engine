# frozen_string_literal: true

module WasteExemptionsEngine
  class Account < ApplicationRecord
    self.table_name = "accounts"

    belongs_to :registration, class_name: "Registration", optional: true
    has_many :orders, as: :order_owner, dependent: :destroy
    has_many :payments, dependent: :destroy
    has_many :charge_adjustments, dependent: :destroy

    delegate :successful_payments, :refunds_and_reversals, to: :payments

    def overpaid?
      balance.positive?
    end

    def balance
      AccountBalanceService.run(self)
    end

    def sorted_orders
      orders.order(created_at: :desc)
    end
  end
end
