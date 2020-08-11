# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class NotifyService < BaseService
    def run(email:, name:)
      client.send_email(email_address: email,
                        template_id: template,
                        personalisation: personalisation(name: name))
    end

    private

    def client
      @_client ||= Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)
    end

    def template
      "4ea25669-1203-4ed7-8f0f-45f0dcaa8199"
    end

    def personalisation(name:)
      {
        name: name
      }
    end
  end
end
