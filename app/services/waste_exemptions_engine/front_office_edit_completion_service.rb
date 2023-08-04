# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditCompletionService < BaseService
    def run(edit_registration:)
      @edit_registration = edit_registration

      ActiveRecord::Base.transaction do
        find_original_registration
        copy_data_from_edit_registration
        copy_exemptions
        delete_edit_registration
      end
    end

    private

    def find_original_registration
      @registration = Registration.where(reference: @edit_registration.reference).first
    end

    def copy_data_from_edit_registration
      copy_attributes

      save_registration_if_changed
    end

    def copy_exemptions
      @registration.exemptions = @edit_registration.exemptions
      @registration.save!
    end

    def delete_edit_registration
      @edit_registration.destroy
    end

    def copy_attributes
      @registration.attributes = @edit_registration.registration_attributes
    end

    def save_registration_if_changed
      @registration.save! if @registration.changed?
    end
  end
end
