# frozen_string_literal: true

module WasteExemptionsEngine
  class BackOfficeEditRegistration < TransientRegistration
    include CanUseBackOfficeEditRegistrationWorkflow
    include CanCopyDataFromRegistration

    private

    def default_workflow_state
      "back_office_edit_form"
    end
  end
end
