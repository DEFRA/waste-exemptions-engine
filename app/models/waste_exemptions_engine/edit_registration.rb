# frozen_string_literal: true

module WasteExemptionsEngine
  class EditRegistration < TransientRegistration
    include CanUseEditRegistrationWorkflow
    include CanCopyDataFromRegistration
  end
end
