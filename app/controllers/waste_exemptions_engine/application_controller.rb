# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicationController < ::ApplicationController
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    # Use the host application's default layout
    layout "application"
  end
end
