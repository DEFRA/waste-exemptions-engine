# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationReceivedPendingPaymentForm < BaseForm
    delegate :order, :exemptions, :reference, :applicant_email, :contact_email, to: :transient_registration
    delegate :total_charge, to: :exemption_costs_presenter

    # Override BaseForm method as users shouldn't be able to submit this form
    def submit(_params)
      raise UnsubmittableForm
    end

    def self.can_navigate_flexibly?
      false
    end

    def exemption_costs_presenter
      @exemption_costs_presenter ||= WasteExemptionsEngine::ExemptionCostsPresenter.new(order:)
    end
  end
end
