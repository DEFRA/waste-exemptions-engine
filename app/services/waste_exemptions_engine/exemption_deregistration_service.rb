# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class ExemptionDeregistrationService < BaseService
    def run(transient_registration)
      @transient_registration = transient_registration
      @original_registration = transient_registration.registration
      @contact_email = @original_registration.contact_email

      case registration_exemptions_delta.length
      when 0
        return false
      when @original_registration.registration_exemptions.length
        full_deregister
      else
        partial_deregister
      end

      true
    end

    private

    def registration_exemptions_delta
      # Avoid an N+1 condition:
      ActiveRecord::Associations::Preloader.new(
        records: [@original_registration], associations: [{ registration_exemptions: [:exemption] }]
      ).call
      exemptions_delta_ids ||= (@original_registration.exemptions - @transient_registration.exemptions).pluck(:id)
      @registration_exemptions_delta ||=
        @original_registration.registration_exemptions.where(exemption_id: exemptions_delta_ids)
    end

    def full_deregister
      deregister_exemptions(@original_registration.registration_exemptions)
      create_paper_trail_version
      DeregistrationConfirmationEmailService.run(registration: @original_registration, recipient: @contact_email)
    end

    def partial_deregister
      deregister_exemptions(registration_exemptions_delta)
      create_paper_trail_version
      RegistrationEditConfirmationEmailService.run(registration: @original_registration, recipient: @contact_email)
    end

    def deregister_exemptions(registration_exemptions)
      registration_exemptions.update_all(
        state: "ceased",
        deregistration_message: I18n.t("self_serve_deregistration.message"),
        deregistered_at: Time.zone.now
      )
    end

    def create_paper_trail_version
      @original_registration.paper_trail.save_with_version
    end
  end
end
