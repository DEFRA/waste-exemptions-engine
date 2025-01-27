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

        if @transient_registration.workflow_state == "beta_start_form"
          participant = WasteExemptionsEngine::BetaParticipant.find_by(registration: @transient_registration)
          if participant.present?
            return send(:"new_#{@transient_registration.workflow_state}_path",
                        participant_token: participant.token)
          end
        end

        send(:"new_#{@transient_registration.workflow_state}_path", token: @transient_registration.token)
      end
    end
  end
end
