# frozen_string_literal: true

class SuppressParamsLoggingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    if suppress_logging?(request)
      Rails.logger.warn "\n**** SUPPRESSING logging of parameters for \"#{request.path}\": #{env["action_dispatch.request.parameters"]}\n"
      Rails.logger.warn "\n**** SUPPRESSING logging of form_hash for \"#{request.path}\": #{env["rack.request.form_hash"]}\n"
      Rails.logger.warn "\n**** SUPPRESSING logging of form_input for \"#{request.path}\": #{env["rack.request.form_input"]}\n"
      env["action_dispatch.request.parameters"] = {}
      env["rack.request.form_hash"] = {}
      env["rack.request.form_input"] = StringIO.new("")
    end

    @app.call(env)
  end

  private

  def suppress_logging?(request)
    # Prevent rails from logging full webhook details
    webhook_path = "/govpay_payment_update"
    request.path.match(/#{webhook_path}$/)
  end
end

Rails.application.config.middleware.insert_before Rails::Rack::Logger, SuppressParamsLoggingMiddleware
