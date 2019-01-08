# frozen_string_literal: true

module WasteExemptionsEngine
  class TransientRegistration < ActiveRecord::Base
    include CanChangeWorkflowStatus

    self.table_name = "transient_registrations"

    after_create :apply_reference

    # HasSecureToken provides an easy way to generate unique random tokens for
    # any model in ruby on rails. We use it to uniquely identify an registration
    # by something other than it's db ID, or its reference number. We can then
    # use token instead of ID to identify an registration during the journey. The
    # format makes it sufficiently hard for another user to attempt to 'guess'
    # the token of another registration in order to see its details.
    # See https://github.com/robertomiranda/has_secure_token
    has_secure_token
    validates_presence_of :token, on: :save

    has_many :transient_addresses, dependent: :destroy
    has_many :transient_registration_exemptions, dependent: :destroy
    has_many :exemptions, through: :transient_registration_exemptions

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

    def registration_attributes
      attributes
        .except(
          "id", "token", "workflow_state", "start_option",
          "declaration", "temp_operator_postcode",
          "temp_contact_postcode", "temp_site_postcode",
          "temp_grid_reference", "temp_site_description",
          "address_finder_error", "transient_addresses",
          "transient_registration_exemptions",
          "created_at", "updated_at"
        )
    end

    private

    def find_address_by_type(address_type)
      return nil unless transient_addresses.present?

      transient_addresses.where(address_type: address_type).first
    end

    def apply_reference
      self.reference = format("WEX%06d", id)
      save!
    end
  end
end
