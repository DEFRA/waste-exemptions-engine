# frozen_string_literal: true

module WasteExemptionsEngine
  class EditedRegistration < TransientRegistration
    after_initialize :copy_data_from_registration

    private

    def copy_data_from_registration
      registration = Registration.where(reference: reference).first

      attributes = registration.attributes.except("id",
                                                  "created_at",
                                                  "updated_at")

      assign_attributes(attributes)
    end

    def apply_reference
      refactor(:apply_reference)
    end

    def refactor(method)
      Rails.logger.debug "This method #{method} should not be on EditedRegistration. Refactor to NewRegistration."
    end
  end
end
