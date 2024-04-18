# frozen_string_literal: true

module WasteExemptionsEngine
  class TransientRegistration < ApplicationRecord
    include CanHaveRegistrationAttributes

    self.table_name = "transient_registrations"

    # HasSecureToken provides an easy way to generate unique random tokens for
    # any model in ruby on rails. We use it to uniquely identify an registration
    # by something other than it's db ID, or its reference number. We can then
    # use token instead of ID to identify an registration during the journey. The
    # format makes it sufficiently hard for another user to attempt to 'guess'
    # the token of another registration in order to see its details.
    # See https://api.rubyonrails.org/classes/ActiveRecord/SecureToken/ClassMethods.html#method-i-has_secure_token
    has_secure_token
    validates_presence_of :token, on: :save

    has_many :transient_addresses, dependent: :destroy

    # In this case, we have to pass the correct enum value, as `enum` will not generate the right query in this case.
    has_one :site_address, -> { where(address_type: 3) }, class_name: "TransientAddress", dependent: :destroy
    has_one :contact_address, -> { where(address_type: 2) }, class_name: "TransientAddress", dependent: :destroy
    has_one :operator_address, -> { where(address_type: 1) }, class_name: "TransientAddress", dependent: :destroy
    accepts_nested_attributes_for :site_address
    accepts_nested_attributes_for :contact_address
    accepts_nested_attributes_for :operator_address

    has_many :transient_people, dependent: :destroy
    has_many :transient_registration_exemptions, dependent: :destroy
    has_many :exemptions, through: :transient_registration_exemptions

    alias addresses transient_addresses
    def addresses=(address_array)
      update(transient_addresses: address_array)
    end
    alias people transient_people
    def people=(people_array)
      update(transient_people: people_array)
    end
    alias registration_exemptions transient_registration_exemptions
    def registration_exemptions=(registration_exemptions_array)
      update(transient_registration_exemptions: registration_exemptions_array)
    end

    TRANSIENT_ATTRIBUTES = %w[address_finder_error
                              companies_house_updated_at
                              created_at
                              declaration
                              excluded_exemptions
                              id
                              reference
                              start_option
                              temp_confirm_exemption_edits
                              temp_confirm_no_exemption_changes
                              temp_contact_postcode
                              temp_grid_reference
                              temp_operator_postcode
                              temp_renew_without_changes
                              temp_reuse_address_for_site_location
                              temp_reuse_applicant_email
                              temp_reuse_applicant_name
                              temp_reuse_applicant_phone
                              temp_reuse_operator_address
                              temp_site_description
                              temp_site_postcode
                              temp_use_registered_company_details
                              token
                              transient_addresses
                              transient_people
                              transient_registration_exemptions
                              type
                              updated_at
                              workflow_history
                              workflow_state].freeze

    def renewal?
      false
    end

    def registration_attributes
      SafeCopyRegistrationAttributesService.run(source: self,
                                                target_class: WasteExemptionsEngine::Registration,
                                                exclude: TRANSIENT_ATTRIBUTES)
    end

    def next_state!
      previous_state = workflow_state
      next!
      workflow_history << previous_state unless previous_state.nil?
      save!
    rescue AASM::UndefinedState, AASM::InvalidTransition => e
      Airbrake.notify(e, reference) if defined?(Airbrake)
      Rails.logger.warn "Failed to transition to next workflow state, registration #{reference}: #{e}"
    end

    def previous_valid_state!
      return unless workflow_history&.length

      last_popped = nil
      until workflow_history.empty?
        last_popped = workflow_history.pop
        break if valid_state?(last_popped) && last_popped != workflow_state

        last_popped = nil
      end
      self.workflow_state = last_popped || default_workflow_state
      save!
    end

    private

    def default_workflow_state
      "start_form"
    end

    def valid_state?(state)
      return false unless state.present?

      valid_state_names.include? state.to_sym
    end

    def valid_state_names
      @valid_state_names ||= aasm.states.map(&:name)
    end
  end
end
