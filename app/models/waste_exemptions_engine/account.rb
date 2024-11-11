# frozen_string_literal: true

module WasteExemptionsEngine
  class Account < ApplicationRecord
    self.table_name = "accounts"

    belongs_to :registration, class_name: "Registration", optional: true
    has_many :orders, as: :order_owner, dependent: :destroy
    has_many :payments, dependent: :destroy

    def balance
      AccountBalanceService.run(self)
    end

  end
end
