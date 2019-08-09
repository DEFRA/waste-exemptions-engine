# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationCompletionService < BaseService
    def run(transient_registration:)
      @transient_registration = transient_registration
      @registration = nil

      @transient_registration.with_lock do
        # This update is necessary as this will make the `with_lock` prevent race conditions
        @transient_registration.update(workflow_state: :creating_registration)

        activate_exemptions

        @registration = Registration.new(copyable_attributes)
        copy_addresses
        copy_exemptions
        copy_people

        add_metadata

        @registration.save!

        @transient_registration.destroy
      end

      send_confirmation_email

      @registration
    rescue StandardError => e
      Airbrake.notify(e, reference: @registration&.reference) if defined?(Airbrake)
      Rails.logger.error "Completing registration error: #{e}"

      raise e
    end

    private

    def activate_exemptions
      @transient_registration.transient_registration_exemptions.each(&:activate)
    end

    def copyable_attributes
      if @transient_registration.company_no_required?
        @transient_registration.registration_attributes
      else
        @transient_registration.registration_attributes.except("company_no")
      end
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

    def copy_people
      return unless include_people?

      @transient_registration.transient_people.each do |trans_person|
        @registration.people << Person.new(trans_person.person_attributes)
      end
    end

    def add_metadata
      @registration.assistance_mode = WasteExemptionsEngine.configuration.default_assistance_mode
      @registration.submitted_at = Date.today
    end

    def include_people?
      [TransientRegistration::BUSINESS_TYPES[:partnership]].include?(@transient_registration.business_type)
    end

    def send_confirmation_email
      distinct_recipients.each do |recipient|
        ConfirmationMailer.send_confirmation_email(@registration, recipient).deliver_now
      end
    rescue StandardError => e
      Airbrake.notify(e, reference: @registration.reference) if defined?(Airbrake)
      Rails.logger.error "Confirmation email error: #{e}"
    end

    def distinct_recipients
      [@registration.applicant_email, @registration.contact_email].map(&:downcase).uniq
    end
  end
end
