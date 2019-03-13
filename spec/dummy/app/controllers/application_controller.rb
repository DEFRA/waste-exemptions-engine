class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # This method exists so we can simulate the existence of Devise in some of our tests.
  def current_user
    raise NotImplementedError
  end
end
