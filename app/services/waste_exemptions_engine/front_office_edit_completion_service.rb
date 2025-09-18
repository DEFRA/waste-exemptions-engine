# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditCompletionService < BaseService
    def run(edit_registration:)
      @edit_registration = edit_registration

      ActiveRecord::Base.transaction do
        find_original_registration
        set_paper_trail_whodunnit
        set_paper_trail_reason
        copy_attributes if non_exemption_changes?
        copy_addresses if non_exemption_changes?
        update_exemptions if exemption_changes?
        send_confirmation_email if non_exemption_changes? && !exemption_changes?
        delete_edit_registration
      end
    end

    private

    def find_original_registration
      scope = Registration.where(reference: @edit_registration.reference)
      scope = preload_registration_exemptions_if_needed(scope)
      @registration = scope.first
    end

    def preload_registration_exemptions_if_needed(scope)
      return scope unless non_exemption_changes?

      scope.preload(addresses: :registration_exemptions)
    end

    def set_paper_trail_whodunnit
      if @registration.edit_link_requested_by.present?
        PaperTrail.request.whodunnit = @registration.edit_link_requested_by
        @registration.edit_link_requested_by = nil
      elsif @registration.contact_email.present?
        PaperTrail.request.whodunnit = @registration.contact_email
      end
    end

    def set_paper_trail_reason
      @edit_registration.update(reason_for_change: I18n.t(".waste_exemptions_engine.edited_via_self_serve_reason"))
    end

    def copy_attributes
      @registration.attributes = @edit_registration.registration_attributes
      @registration.save!
    end

    def copy_addresses
      @registration.addresses = []
      @edit_registration.transient_addresses.each do |transient_address|
        new_address = Address.new(transient_address.address_attributes)
        @registration.addresses << new_address
      end
    end

    def update_exemptions
      ExemptionDeregistrationService.run(@edit_registration)
    end

    def exemption_changes?
      @exemption_changes ||=
        @registration.exemptions.pluck(:code).sort != @edit_registration.exemptions.pluck(:code).sort
    end

    def non_exemption_changes?
      @non_exemption_changes ||= @edit_registration.modified?(ignore_exemptions: true)
    end

    def send_confirmation_email
      RegistrationEditConfirmationEmailService
        .run(registration: @registration, recipient: @edit_registration.contact_email)
    end

    def delete_edit_registration
      @edit_registration.destroy
    end
  end
end
