# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditCompletionService < BaseService
    def run(edit_registration:)
      @edit_registration = edit_registration

      ActiveRecord::Base.transaction do
        find_original_registration
        copy_attributes if non_exemption_changes?
        copy_addresses if non_exemption_changes?
        update_exemptions if exemption_changes?
        send_confirmation_email if non_exemption_changes? && !exemption_changes?
        delete_edit_registration
      end
    end

    private

    def find_original_registration
      @registration = Registration.where(reference: @edit_registration.reference).first
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
      @non_exemption_changes ||= @edit_registration.modified?
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
