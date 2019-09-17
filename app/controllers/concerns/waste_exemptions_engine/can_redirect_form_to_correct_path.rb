# frozen_string_literal: true

module WasteExemptionsEngine
  module CanRedirectFormToCorrectPath
    extend ActiveSupport::Concern

    included do
      def redirect_to_correct_form(
        status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE
      )
        redirect_to form_path, status: status_code
      end

      # Get the path based on the workflow state
      def form_path
        @transient_registration.save unless @transient_registration.token.present?

        send("new_#{@transient_registration.workflow_state}_path".to_sym, token: @transient_registration.token)
      end
    end
  end
end
