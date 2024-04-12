# frozen_string_literal: true

module WasteExemptionsEngine
  class UnsubscribeController < ::ApplicationController
    def unsubscribe
      registration = Registration.find_by(unsubscribe_token: params[:unsubscribe_token])
      if registration
        registration.update(reminder_opt_in: false)
        redirect_to unsubscribe_registration_successful_path
      else
        redirect_to unsubscribe_registration_failed_path
      end
    end

    def unsubscribe_successful
      # This method is empty to display the view
    end

    def unsubscribe_failed
      # This method is empty to display the view
    end
  end
end
