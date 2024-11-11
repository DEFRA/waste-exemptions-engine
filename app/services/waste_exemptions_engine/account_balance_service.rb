# frozen_string_literal: true

module WasteExemptionsEngine
  class AccountBalanceService < BaseService
    attr_reader :account

    def run(account)
      @account = account
      total_paid - total_due
    end

    private

    def total_due
      account.orders.sum(&:total_charge_amount) || 0
    end

    def total_paid
      account.payments.select(&:success?).sum(&:payment_amount) || 0
    end
  end
end
