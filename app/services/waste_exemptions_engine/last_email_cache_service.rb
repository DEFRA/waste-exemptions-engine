# frozen_string_literal: true

require "singleton"
require "json"

module WasteExemptionsEngine
  class LastEmailCacheService
    include Singleton

    EMAIL_ATTRIBUTES = %i[date from to bcc cc reply_to subject].freeze

    attr_accessor :last_email

    def self.delivering_email(message)
      instance.last_email = message
    end

    # This is necessary to properly test the service functionality
    def reset
      @last_email = nil
    end

    def last_email_json
      return JSON.generate(error: "No emails sent.") unless last_email.present?

      message_hash = {}
      EMAIL_ATTRIBUTES.each do |attribute|
        message_hash[attribute] = last_email.public_send(attribute)
      end
      message_hash[:body] = last_email.parts.first.body.to_s
      message_hash[:attachments] = last_email.attachments.map(&:filename)

      JSON.generate(last_email: message_hash)
    end
  end
end

ActionMailer::Base.register_interceptor(WasteExemptionsEngine::LastEmailCacheService)
