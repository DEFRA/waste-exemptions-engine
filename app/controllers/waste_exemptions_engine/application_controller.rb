# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicationController < ::ApplicationController
    # A successful POST request redirects to the next form in the work flow. We have chosen to
    # differentiate 'good' rediection as 303 and 'bad' redirection as 302.
    UNSUCCESSFUL_REDIRECTION_CODE = 302
    SUCCESSFUL_REDIRECTION_CODE = 303

    # Collect analytics data
    after_action :record_user_journey

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    # Use the host application's default layout
    layout "application"

    default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

    before_action :set_paper_trail_whodunnit

    def user_for_paper_trail
      if WasteExemptionsEngine.configuration.use_current_user_for_whodunnit && current_user.present?
        current_user.id
      else
        "public user"
      end
    end

    def record_user_journey
      return unless @transient_registration.present? && @transient_registration.token.present?

      begin
        user = current_user
      rescue NotImplementedError
        # do nothing
      end

      WasteExemptionsEngine::Analytics::UserJourneyService.run(
        transient_registration: @transient_registration,
        current_user: user
      )
    end

    def current_user
      return unless defined?(super)

      super
    end
  end
end
