unless Rails.env.development? || Rails.env.test?
  Rails.application.config.exceptions_app = WasteExemptionsEngine::Engine.routes
end
