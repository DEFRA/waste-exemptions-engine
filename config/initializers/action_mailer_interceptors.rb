# frozen_string_literal: true

if WasteExemptionsEngine.configuration.use_last_email_cache
  ActionMailer::Base.register_interceptor(WasteExemptionsEngine::LastEmailCacheService)
end
