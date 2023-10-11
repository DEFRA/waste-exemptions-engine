# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicationController < ::ApplicationController
    # A successful POST request redirects to the next form in the work flow. We have chosen to
    # differentiate 'good' rediection as 303 and 'bad' redirection as 302.
    UNSUCCESSFUL_REDIRECTION_CODE = 302
    SUCCESSFUL_REDIRECTION_CODE = 303

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    # Use the host application's default layout
    layout "application"

    default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

    before_action :set_paper_trail_whodunnit

    rescue_from StandardError, with: :log_unhandled_exception

    def log_unhandled_exception(exception)
      Rails.logger.error "Unhandled exception for registration #{@transient_registration&.reference}: #{exception}"
      Airbrake.notify(exception, reference: @transient_registration&.reference) if defined?(Airbrake)

      raise exception
    end

    def user_for_paper_trail
      if WasteExemptionsEngine.configuration.use_current_user_for_whodunnit
        current_user.id
      else
        "public user"
      end
    end
  end
end
