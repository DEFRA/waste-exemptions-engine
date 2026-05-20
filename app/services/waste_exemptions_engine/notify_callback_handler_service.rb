# frozen_string_literal: true

module WasteExemptionsEngine
  class NotifyCallbackHandlerService < BaseService
    NOTIFICATION_STATUSES = %w[delivered permanent-failure technical-failure returned].freeze

    def run(callback_payload)
      @payload = callback_payload.deep_symbolize_keys

      if @payload.key?(:notification_type)
        process_delivery_receipt
      elsif @payload.key?(:notification_id) && !@payload.key?(:status)
        process_returned_letter
      else
        raise ArgumentError, "Unrecognised Notify callback payload"
      end
    end

    private

    def process_delivery_receipt
      notification_id = @payload[:id]
      new_status = @payload[:status]

      raise ArgumentError, "Missing id in delivery receipt" if notification_id.blank?
      raise ArgumentError, "Missing status in delivery receipt" if new_status.blank?

      update_communication_log(notification_id, new_status)
    end

    def process_returned_letter
      notification_id = @payload[:notification_id]

      raise ArgumentError, "Missing notification_id in returned letter" if notification_id.blank?

      update_communication_log(notification_id, "returned")
    end

    def update_communication_log(notification_id, new_status)
      communication_log = CommunicationLog.find_by(notification_id: notification_id)

      unless communication_log
        Rails.logger.warn "CommunicationLog not found for notification_id: #{notification_id}"
        return { notification_id: notification_id, status: "not_found" }
      end

      if NOTIFICATION_STATUSES.include?(communication_log.status)
        Rails.logger.info "Ignoring Notify callback for notification_id #{notification_id}: " \
                          "already in terminal status '#{communication_log.status}'"
        return { notification_id: notification_id, status: communication_log.status }
      end

      communication_log.update!(status: new_status)

      { notification_id: notification_id, status: new_status }
    end
  end
end
