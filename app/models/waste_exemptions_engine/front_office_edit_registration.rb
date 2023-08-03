# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditRegistration < TransientRegistration
    include CanUseFrontOfficeEditRegistrationWorkflow
    include CanCopyDataFromRegistration

    private

    def default_workflow_state
      "front_office_edit_form"
    end
  end
end
