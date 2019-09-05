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

    # In this case, we have to pass the correct enum value, as `enum` will not generate the right query in this case.
    has_one :transient_site_address, -> { where(address_type: 3) }, class_name: "TransientAddress"
    has_one :transient_contact_address, -> { where(address_type: 2) }, class_name: "TransientAddress"
    has_one :transient_operator_address, -> { where(address_type: 1) }, class_name: "TransientAddress"
    accepts_nested_attributes_for :transient_site_address
    accepts_nested_attributes_for :transient_contact_address
    accepts_nested_attributes_for :transient_operator_address

    has_many :transient_people, dependent: :destroy
    has_many :transient_registration_exemptions, dependent: :destroy
    has_many :exemptions, through: :transient_registration_exemptions

    alias_attribute :addresses, :transient_addresses
    alias_attribute :people, :transient_people
    alias_attribute :registration_exemptions, :transient_registration_exemptions

    TRANSIENT_ATTRIBUTES = %w[address_finder_error
                              created_at
                              declaration
                              reference
                              id
                              start_option
                              temp_operator_postcode
                              temp_contact_postcode
                              temp_grid_reference
                              temp_site_description
                              temp_site_postcode
                              temp_renew_without_changes
                              token
                              transient_addresses
                              transient_registration_exemptions
                              transient_people
                              type
                              updated_at
                              workflow_state].freeze

    def renewal?
      false
    end

    def registration_attributes
      attributes.except(*TRANSIENT_ATTRIBUTES)
    end
  end
end
