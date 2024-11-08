# frozen_string_literal: true

module WasteExemptionsEngine
  class Account < ApplicationRecord
    self.table_name = "accounts"

    belongs_to :registration, class_name: "Registration", optional: true
    has_many :orders, as: :order_owner, dependent: :destroy
    has_many :payments, dependent: :destroy

    def update_balance!
      self.balance = orders.sum(&:total_charge_amount) - payments.sum(&:payment_amount)
    end
  end
end
