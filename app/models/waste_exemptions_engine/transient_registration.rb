# frozen_string_literal: true

module WasteExemptionsEngine
  class TransientRegistration < ActiveRecord::Base
    include CanHaveRegistrationAttributes
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
    has_many :transient_people, dependent: :destroy
    has_many :transient_registration_exemptions, dependent: :destroy
    has_many :exemptions, through: :transient_registration_exemptions

    alias_attribute :addresses, :transient_addresses
    alias_attribute :people, :transient_people
    alias_attribute :registration_exemptions, :transient_registration_exemptions

    def registration_attributes
      attributes
        .except(
          "id", "token", "workflow_state", "start_option",
          "declaration", "temp_operator_postcode",
          "temp_contact_postcode", "temp_site_postcode",
          "temp_grid_reference", "temp_site_description",
          "address_finder_error", "transient_addresses",
          "transient_registration_exemptions", "transient_people",
          "created_at", "updated_at", "type"
        )
    end

    private

    def apply_reference
      self.reference = format("WEX%06d", id)
      save!
    end
  end
end
