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
      base_total = account&.orders&.sum { |x| x.total_charge_amount || 0 } || 0
      total_adjustments + base_total
    end

    def total_paid
      account.payments&.select(&:success?)&.sum { |x| x.payment_amount || 0 } || 0
    end

    def total_adjustments
      account&.charge_adjustments&.sum do |adjustment|
        adjustment.increase? ? adjustment.amount : -adjustment.amount
      end
    end
  end
end
