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
      llp_or_ltd?
    end

    def llp_or_ltd?
      [BUSINESS_TYPES[:limited_company],
       BUSINESS_TYPES[:limited_liability_partnership]].include?(business_type)
    end

    def partnership?
      BUSINESS_TYPES[:partnership] == business_type
    end
  end
end
