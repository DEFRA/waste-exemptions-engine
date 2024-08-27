# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationReceivedPendingPaymentFormsController < FormsController
    helper PluralsHelper

    include CannotGoBackForm
    include CannotSubmitForm

    def new
      return unless super(RegistrationReceivedPendingPaymentForm, "registration_received_pending_payment_form")

      @registration = RegistrationCompletionService.run(transient_registration: @transient_registration)
    end
  end
end
