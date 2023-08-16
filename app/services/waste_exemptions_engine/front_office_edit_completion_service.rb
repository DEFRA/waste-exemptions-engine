# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditCompletionService < BaseService
    def run(edit_registration:)
      @edit_registration = edit_registration

      ActiveRecord::Base.transaction do
        find_original_registration
        has_exemption_changes = registration_changed_with_exemption_changes
        has_non_exemption_changes = registration_changed_without_exemption_changes
        copy_attributes
        update_exemptions if has_exemption_changes
        save_registration_if_changed
        complete_non_exemptions_update if has_non_exemption_changes
        delete_edit_registration
      end
    end

    private

    def find_original_registration
      @registration = Registration.where(reference: @edit_registration.reference).first
    end

    def copy_attributes
      @registration.attributes = @edit_registration.registration_attributes
    end

    def update_exemptions
      ExemptionDeregistrationService.run(@edit_registration)

      @registration.exemptions = @edit_registration.exemptions
    end

    def registration_changed_with_exemption_changes
      @registration.exemptions.pluck(:code).sort != @edit_registration.exemptions.pluck(:code).sort
    end

    def registration_changed_without_exemption_changes
      return false if registration_changed_with_exemption_changes

      @edit_registration.modified?
    end

    def complete_non_exemptions_update
      create_paper_trail_version
      RegistrationEditConfirmationEmailService.run(registration: @registration, recipient: @registration.contact_email)
    end

    def delete_edit_registration
      @edit_registration.destroy
    end

    def save_registration_if_changed
      @registration.save! if @registration.changed?
    end

    def create_paper_trail_version
      @registration.paper_trail.save_with_version
    end
  end
end
