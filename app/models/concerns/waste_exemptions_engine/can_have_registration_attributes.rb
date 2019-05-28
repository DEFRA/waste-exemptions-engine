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
      [BUSINESS_TYPES[:partnership]].include?(business_type)
    end

    def operator_address
      find_address_by_type("operator")
    end

    def contact_address
      find_address_by_type("contact")
    end

    def site_address
      find_address_by_type("site")
    end

    private

    def find_address_by_type(address_type)
      return nil unless addresses.present?

      addresses.select { |a| a.address_type == address_type }.first
    end
  end
end
