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
        copy_people

        add_metadata
        @registration.save!
        @registration.reference = format("WEX%06d", @registration.id)
        @registration.save!
        @transient_registration.destroy
      end
      send_confirmation_email
    rescue StandardError => e
      Airbrake.notify(e, reference: @registration.reference) if defined?(Airbrake)
      Rails.logger.error "Completing registration error: #{e}"

      raise e
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
      %w[partnership].include?(@transient_registration.business_type)
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
