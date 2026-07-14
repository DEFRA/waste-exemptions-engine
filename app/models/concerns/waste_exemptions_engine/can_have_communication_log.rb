# frozen_string_literal: true

module WasteExemptionsEngine
  module CanHaveCommunicationLog
    extend ActiveSupport::Concern

    included do

      def create_log(registration:, notify_response: nil)
        registration.communication_logs ||= []
        params = communications_log_params
        params.merge!(notify_response_params(notify_response)) if notify_response
        registration.communication_logs << CommunicationLog.new(params)
      rescue NoMethodError => e
        Rails.logger.error "Exception creating communication log: #{e}"
        Airbrake.notify(e, registration: "\"registration&.reference\"")
      end

      private

      def notify_response_params(response)
        {
          notification_id: response.id,
          body: response.content.is_a?(Hash) ? response.content["body"] : nil,
          subject: response.content.is_a?(Hash) ? response.content["subject"] : nil
        }.compact
      end
    end
  end
end
