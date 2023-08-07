# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditCompletionService < BaseService
    def run(edit_registration:)
      @edit_registration = edit_registration

      ActiveRecord::Base.transaction do
        find_original_registration
        copy_attributes
        copy_exemptions
        save_registration_if_changed
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

    def copy_exemptions
      @registration.exemptions = @edit_registration.exemptions
    end

    def delete_edit_registration
      @edit_registration.destroy
    end

    def save_registration_if_changed
      @registration.save! if @registration.changed?
    end
  end
end
