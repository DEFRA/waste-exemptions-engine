# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationCompletionService < BaseService
    # rubocop:disable Metrics/MethodLength
    def run(transient_registration:)
      @transient_registration = transient_registration
      @registration = nil

      @transient_registration.with_lock do
        # This update is necessary as this will make the `with_lock` prevent race conditions
        @transient_registration.update(workflow_state: :creating_registration)
        activate_exemptions

        # Check whether a placeholder registration was created pre-payment
        placeholder_registration = Registration.find_by(reference: @transient_registration.reference,
                                                        placeholder: true)
        if placeholder_registration.present?
          @registration = placeholder_registration
          @registration.update(copyable_attributes.merge(placeholder: false))
        else
          @registration = Registration.new(copyable_attributes)
        end

        copy_addresses
        CopyExemptionsService.run(transient_registration: @transient_registration, registration: @registration)
        copy_people
        copy_charging_attributes
        add_metadata
        @registration.save!
        copy_order if @registration.charged?

        # Memoize the payment_method to supress registration confirmation email
        # if the payment method is bank_transfer
        @payment_method = @transient_registration.temp_payment_method

        # Destroy the transient registration
        @transient_registration.destroy
      end

      send_confirmation_messages
      @registration
    rescue StandardError => e
      Airbrake.notify(e, reference: @registration&.reference) if defined?(Airbrake)
      Rails.logger.error "Completing registration error: #{e}"
      raise e
    end
    # rubocop:enable Metrics/MethodLength

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

    def copy_charging_attributes
      @registration.charged = @transient_registration.charged?
    end

    def copy_order
      account = @registration.account || @registration.create_account(balance: 0)
      account.orders << @transient_registration.order if @transient_registration.order.present?
    end

    def copy_addresses
      site_counter = 0

      @transient_registration.transient_addresses.each do |transient_address|
        address_attrs = transient_address.address_attributes

        if transient_address.site?
          site_counter += 1
          address_attrs["site_suffix"] = format("%05d", site_counter)
        end

        @registration.addresses << Address.new(address_attrs)
      end
    end

    def copy_people
      return unless @transient_registration.partnership?

      @transient_registration.transient_people.each do |trans_person|
        @registration.people << Person.new(trans_person.person_attributes)
      end
    end

    def add_metadata
      @registration.assistance_mode = @transient_registration.assistance_mode ||
                                      WasteExemptionsEngine.configuration.default_assistance_mode
      @registration.submitted_at = Date.today
    end

    def send_confirmation_messages
      send_confirmation_letters if [@registration.contact_email, @registration.applicant_email].none?

      send_confirmation_emails
    end

    def send_confirmation_letter
      NotifyConfirmationLetterService.run(registration: @registration)
    rescue StandardError => e
      Airbrake.notify(e, reference: @registration.reference) if defined?(Airbrake)
      Rails.logger.error "Confirmation letter error: #{e}"
    end

    def send_registration_pending_bank_transfer_letter
      RegistrationPendingBankTransferLetterService.run(registration: @registration)
    rescue StandardError => e
      Airbrake.notify(e, reference: @registration.reference) if defined?(Airbrake)
      Rails.logger.error "Bank transfer letter error: #{e}"
    end

    def send_confirmation_emails
      distinct_recipients.each do |recipient|
        next unless recipient.present?

        if @payment_method == Payment::PAYMENT_TYPE_BANK_TRANSFER
          send_registration_pending_bank_transfer_email(recipient)
        else
          send_confirmation_email(recipient)
        end
      end
    end

    def send_confirmation_letters
      if @payment_method == Payment::PAYMENT_TYPE_BANK_TRANSFER
        send_registration_pending_bank_transfer_letter
      else
        send_confirmation_letter
      end
    end

    def send_confirmation_email(recipient)
      ConfirmationEmailService.run(registration: @registration, recipient: recipient)
    rescue StandardError => e
      Airbrake.notify(e, reference: @registration.reference) if defined?(Airbrake)
      Rails.logger.error "Confirmation email error: #{e}"
    end

    def send_registration_pending_bank_transfer_email(recipient)
      RegistrationPendingBankTransferEmailService.run(registration: @registration, recipient: recipient)
    rescue StandardError => e
      Airbrake.notify(e, reference: @registration.reference) if defined?(Airbrake)
      Rails.logger.error "Registration pending bank transfer email error: #{e}"
    end

    def distinct_recipients
      [@registration.applicant_email, @registration.contact_email].compact.map(&:downcase).uniq
    end
  end
end
