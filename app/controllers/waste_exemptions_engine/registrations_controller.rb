class RegistrationsController < ::ApplicationController
  def unsubscribe
    registration = Registration.find_by(unsubscribe_token: params[:unsubscribe_token])
    if registration
      registration.update(reminder_opt_in: false)
      redirect_to unsubscribe_successful_path
    else
      redirect_to unsubscribe_failed_path
    end
    redirect_to root_path
  end

  def unsubscribe_successful
  end

  def unsubscribe_failed
  end
end
