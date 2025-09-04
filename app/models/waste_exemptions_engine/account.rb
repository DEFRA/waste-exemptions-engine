# frozen_string_literal: true

module WasteExemptionsEngine
  class Account < ApplicationRecord
    self.table_name = "accounts"

    belongs_to :registration, class_name: "Registration", optional: true
    has_many :orders, as: :order_owner, dependent: :destroy
    has_many :payments, dependent: :destroy
    has_many :charge_adjustments, dependent: :destroy

    def site_count
      registration.site_count
    end

    def overpaid?
      balance.positive?
    end

    def balance
      AccountBalanceService.run(self)
    end
  end
end
