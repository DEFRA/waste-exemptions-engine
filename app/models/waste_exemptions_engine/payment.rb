# frozen_string_literal: true

module WasteExemptionsEngine
  class Payment < ApplicationRecord
    self.table_name = "payments"

    # Govpay - currently the only payment provider we use
    PAYMENT_TYPE_GOVPAY = "govpay_payment"
    PAYMENT_TYPE_BANK_TRANSFER = "bank_transfer"
    PAYMENT_TYPE_MISSING_CARD_PAYMENT = "missing_card_payment"
    PAYMENT_TYPE_OTHER = "other_payment"

    enum payment_type: { govpay_payment: PAYMENT_TYPE_GOVPAY, bank_transfer: PAYMENT_TYPE_BANK_TRANSFER,
                         missing_card_payment: PAYMENT_TYPE_MISSING_CARD_PAYMENT, other_payment: PAYMENT_TYPE_OTHER }

    # Payment created using the API. Your user has not yet visited next_url.	finished? false
    PAYMENT_STATUS_CREATED = "created"
    # Your user has visited next_url and is entering their payment details.	  finished? false
    PAYMENT_STATUS_STARTED = "started"
    # Your user submitted payment details and went through authentication, if it was required.  finished? false
    PAYMENT_STATUS_SUBMITTED = "submitted"
    # The payment is a delayed capture and your user has submitted their payment
    # details and selected Confirm. finished? false
    PAYMENT_STATUS_CAPTURABLE = "capturable"
    # Your user successfully completed the payment by selecting Confirm. finished? true
    PAYMENT_STATUS_SUCCESS = "success"
    # The payment failed. This failure could be because the payment timed out after 90 minutes,
    # the user’s payment method was rejected, or your user cancelled the payment. finished? true
    PAYMENT_STATUS_FAILED = "failed"
    # Your service cancelled the payment using an API request or the GOV.UK Pay admin tool. finished? true
    PAYMENT_STATUS_CANCELLED = "cancelled"
    # Something went wrong with GOV.UK Pay or the payment service provider. The payment failed safely
    # with no money taken from the user. finished? true
    PAYMENT_STATUS_ERROR = "error"

    # https://docs.payments.service.gov.uk/api_reference/#payment-status-lifecycle
    enum payment_status: {
      created: PAYMENT_STATUS_CREATED,
      started: PAYMENT_STATUS_STARTED,
      submitted: PAYMENT_STATUS_SUBMITTED,
      capturable: PAYMENT_STATUS_CAPTURABLE,
      success: PAYMENT_STATUS_SUCCESS,
      failed: PAYMENT_STATUS_FAILED,
      cancelled: PAYMENT_STATUS_CANCELLED,
      error: PAYMENT_STATUS_ERROR
    }

    belongs_to :order, optional: true
    belongs_to :account, optional: true

    validates :payment_uuid, presence: true
    validates :payment_type, presence: true
    validates :payment_status, presence: true

    scope :not_cancelled, -> { where.not(payment_status: PAYMENT_STATUS_CANCELLED) }
  end
end
