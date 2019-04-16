# frozen_string_literal: true

module WasteExemptionsEngine
  class EditedRegistration < TransientRegistration
    after_initialize :copy_data_from_registration

    include CanChangeEditWorkflowStatus

    private

    def copy_data_from_registration
      registration = Registration.where(reference: reference).first

      attributes = registration.attributes.except("id",
                                                  "created_at",
                                                  "updated_at")

      assign_attributes(attributes)
    end
  end
end
