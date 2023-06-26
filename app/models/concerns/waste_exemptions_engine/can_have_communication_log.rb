# frozen_string_literal: true

module WasteExemptionsEngine
  module CanHaveCommunicationLog
    extend ActiveSupport::Concern

    included do

      def create_log(registration:)
        registration.communication_logs ||= []
        registration.communication_logs << CommunicationLog.new(communications_log_params)
      rescue NoMethodError => e
        Rails.logger.error "Exception creating communication log: #{e}"
        Airbrake.notify(e, registration: "\"registration&.reference\"")
      end
    end
  end
end
