# frozen_string_literal: true

class SuppressParamsLoggingMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    if suppress_logging?(request)
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
