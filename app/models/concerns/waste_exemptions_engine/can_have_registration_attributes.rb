# frozen_string_literal: true

module WasteExemptionsEngine
  module CanHaveRegistrationAttributes
    extend ActiveSupport::Concern

    BUSINESS_TYPES = HashWithIndifferentAccess.new(
      sole_trader: "soleTrader",
      limited_company: "limitedCompany",
      partnership: "partnership",
      limited_liability_partnership: "limitedLiabilityPartnership",
      local_authority: "localAuthority",
      charity: "charity"
    )

    # Some business types should not have a company_no
    def company_no_required?
      [BUSINESS_TYPES[:limited_company],
       BUSINESS_TYPES[:limited_liability_partnership]].include?(business_type)
    end

    def partnership?
      BUSINESS_TYPES[:partnership] == business_type
    end

    def farm_affiliated?
      is_a_farmer? || on_a_farm?
    end

    def pending_online_payment?
      account_payments = if respond_to?(:account)
                           account.payments
                         else
                           return false if reference.blank?

                           # This is a transient registration so look for the payment on the registration
                           WasteExemptionsEngine::Registration.find_by(reference:).account.payments
                         end

      payment = account_payments.where(payment_type: Payment::PAYMENT_TYPE_GOVPAY).last

      return false if payment.blank?

      GovpayValidatorService.valid_govpay_status?(:pending, payment.payment_status)
    end
  end
end
