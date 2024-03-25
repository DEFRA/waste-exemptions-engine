# frozen_string_literal: true

module WasteExemptionsEngine
  class UnsubscribeLinkService < BaseService
    def run(registration:)
      Rails.configuration.front_office_url +
        WasteExemptionsEngine::Engine
        .routes.url_helpers
        .unsubscribe_registration_path(unsubscribe_token: registration.unsubscribe_token)
    end
  end
end
