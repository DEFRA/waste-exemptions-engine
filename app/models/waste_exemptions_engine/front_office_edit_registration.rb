# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditRegistration < TransientRegistration
    include CanUseFrontOfficeEditRegistrationWorkflow
    include CanCopyDataFromRegistration

    def modified?
      return true if exemptions.pluck(:id).sort != registration.exemptions.pluck(:id).sort

      %i[
        contact_first_name
        contact_last_name
        contact_phone
        contact_email
      ].each do |attr|
        return true if send(attr) != registration.send(attr)
      end

      false
    end

    private

    def default_workflow_state
      "front_office_edit_form"
    end
  end
end
