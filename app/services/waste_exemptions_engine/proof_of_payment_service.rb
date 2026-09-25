# frozen_string_literal: true

module WasteExemptionsEngine
  class ProofOfPaymentService < BaseService
    TEMPLATE_IDS = [
      NotificationTemplates::PROOF_OF_PAYMENT_EMAIL,
      NotificationTemplates::PROOF_OF_PAYMENT_LETTER
    ].freeze

    def run(registration:)
      @registration = registration

      registration.with_lock do
        return unless eligible?
        return if already_sent?

        send_proof_of_payment
      end
    end

    private

    attr_reader :registration

    def eligible?
      account.present? && charged? && fully_paid? && successful_payment?
    end

    def account
      registration.account
    end

    def charged?
      account.orders.includes(:charge_detail).any? do |order|
        order.charge_detail&.total_charge_amount.to_i.positive?
      end
    end

    def fully_paid?
      !account.balance.negative?
    end

    def successful_payment?
      account.payments.any? { |payment| payment.success? && payment.payment_amount.to_i.positive? }
    end

    def already_sent?
      registration.communication_logs.where(template_id: TEMPLATE_IDS).exists?
    end

    def send_proof_of_payment
      if registration.contact_email.present?
        ProofOfPaymentEmailService.run(registration:, recipient: registration.contact_email.downcase)
      else
        ProofOfPaymentLetterService.run(registration:)
      end
    end
  end
end
