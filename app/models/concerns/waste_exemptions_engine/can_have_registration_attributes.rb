# frozen_string_literal: true

module WasteExemptionsEngine
  module CanHaveRegistrationAttributes
    extend ActiveSupport::Concern

    # Some business types should not have a company_no
    def company_no_required?
      %w[limitedCompany limitedLiabilityPartnership].include?(business_type)
    end

    def partnership?
      %w[partnership].include?(business_type)
    end

    def operator_address
      find_address_by_type(TransientAddress.address_types[:operator])
    end

    def contact_address
      find_address_by_type(TransientAddress.address_types[:contact])
    end

    def site_address
      find_address_by_type(TransientAddress.address_types[:site])
    end

    private

    def find_address_by_type(address_type)
      if addresses.present?
        addresses.where(address_type: address_type).first
      else
        find_transient_address_by_type(address_type)
      end
    end

    def find_transient_address_by_type(address_type)
      return nil unless transient_addresses.present?

      transient_addresses.where(address_type: address_type).first
    end
  end
end
