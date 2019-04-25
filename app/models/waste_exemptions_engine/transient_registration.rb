# frozen_string_literal: true

module WasteExemptionsEngine
  class TransientRegistration < ActiveRecord::Base
    include CanHaveRegistrationAttributes

    self.table_name = "transient_registrations"

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

    ATTRIBUTES_NOT_COPIED_TO_REGISTRATION = %w[address_finder_error
                                               created_at
                                               declaration
                                               id
                                               start_option
                                               temp_operator_postcode
                                               temp_contact_postcode
                                               temp_grid_reference
                                               temp_site_description
                                               temp_site_postcode
                                               token
                                               transient_addresses
                                               transient_registration_exemptions
                                               transient_people
                                               type
                                               updated_at
                                               workflow_state].freeze

    def registration_attributes
      attributes.except(*ATTRIBUTES_NOT_COPIED_TO_REGISTRATION)
    end
  end
end
