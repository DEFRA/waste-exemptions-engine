# frozen_string_literal: true

module WasteExemptionsEngine
  class Registration < ActiveRecord::Base

    self.table_name = "registrations"

    has_many :addresses
    has_many :registration_exemptions
    has_many :exemptions, through: :registration_exemptions

    # Some business types should not have a company_no
    def company_no_required?
      %w[limitedCompany limitedLiabilityPartnership].include?(business_type)
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
      return nil unless addresses.present?

      addresses.where(address_type: address_type).first
    end

    def apply_reference
      self.reference = format("WEX%06d", id)
      save!
    end
  end
end
