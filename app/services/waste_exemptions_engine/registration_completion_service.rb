# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationCompletionService
    def initialize(transient_registration)
      @transient_registration = transient_registration
    end

    def complete
      ActiveRecord::Base.transaction do
        activate_exemptions

        @registration = Registration.new(@transient_registration.registration_attributes)
        copy_addresses
        copy_exemptions
        copy_key_people

        @registration.save!
        @transient_registration.destroy
      end
    end

    private

    def activate_exemptions
      @transient_registration.transient_registration_exemptions.each(&:activate)
    end

    def copy_addresses
      @transient_registration.transient_addresses.each do |transient_address|
        @registration.addresses << Address.new(transient_address.address_attributes)
      end
    end

    def copy_exemptions
      @transient_registration.transient_registration_exemptions.each do |trans_exemption|
        @registration.registration_exemptions << RegistrationExemption.new(trans_exemption.exemption_attributes)
      end
    end

    def copy_key_people
      return unless include_key_people?

      @transient_registration.transient_key_people.each do |trans_person|
        @registration.key_people << KeyPerson.new(trans_person.key_person_attributes)
      end
    end

    def include_key_people?
      %w[partnership].include?(@transient_registration.business_type)
    end
  end
end
