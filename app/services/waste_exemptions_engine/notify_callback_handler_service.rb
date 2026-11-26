# frozen_string_literal: true

module WasteExemptionsEngine
  class NotifyCallbackHandlerService < BaseService
    TERMINAL_STATUSES = %w[delivered permanent-failure technical-failure returned].freeze

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

      update_communication_logs(notification_id, new_status)
    end

    def process_returned_letter
      notification_id = @payload[:notification_id]

      raise ArgumentError, "Missing notification_id in returned letter" if notification_id.blank?

      update_communication_logs(notification_id, "returned")
    end

    # A single notification can be linked to several communication logs, one per registration,
    # e.g. when one email is sent to a contact email address shared by several registrations
    def update_communication_logs(notification_id, new_status)
      communication_logs = logs_for(notification_id)

      if communication_logs.empty?
        Rails.logger.warn "CommunicationLog not found for notification_id: #{notification_id}"
        return { notification_id: notification_id, status: "not_found" }
      end

      logs_to_update = communication_logs.reject { |log| TERMINAL_STATUSES.include?(log.status) }

      if logs_to_update.empty?
        Rails.logger.info "Ignoring Notify callback for notification_id #{notification_id}: " \
                          "already in terminal status '#{communication_logs.first.status}'"
        return { notification_id: notification_id, status: communication_logs.first.status }
      end

      CommunicationLog.where(id: logs_to_update).update_all(status: new_status, updated_at: Time.zone.now)

      { notification_id: notification_id, status: new_status }
    end

    # A log written before its message was sent still holds the placeholder we gave Notify as the reference
    def logs_for(notification_id)
      CommunicationLog.where(notification_id: [notification_id, @payload[:reference]].compact).to_a
    end
  end
end
