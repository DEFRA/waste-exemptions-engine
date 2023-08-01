# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditRegistration < TransientRegistration
    include CanUseFrontOfficeEditRegistrationWorkflow
    include CanCopyDataFromRegistration

    # after_initialize :copy_data_from_registration, if: :new_record?

    # ################################################### temp until merged with token generation changes
    # def edit_token
    #   @temp_token || "123456789"
    # end

    # def edit_token=(token)
    #   @temp_token = token
    # end

    # def edit_token_created_at
    #   @temp_token_created_at || 1.hour.ago
    # end

    # def edit_token_created_at=(created_at)
    #   @temp_token_created = created_at
    # end
    # ################################################### temp until merged with token generation changes

    private

    # def registration
    #   @registration ||= Registration.find_by(reference: reference)
    # end

    # def copy_data_from_registration
    #   self.exemptions = registration.active_exemptions
    # end

    def default_workflow_state
      "front_office_edit_form"
    end
  end
end
