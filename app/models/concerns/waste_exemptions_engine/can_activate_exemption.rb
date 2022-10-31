# frozen_string_literal: true

module WasteExemptionsEngine
  module CanActivateExemption
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :state do
        state :pending, initial: true
        state :active

        event :activate do
          transitions from: :pending,
                      to: :active,
                      after: :activate_exemption
        end

      end

      # rubocop:disable Style/ConditionalAssignment
      def activate_exemption
        self.registered_on = Date.today

        if transient_registration.is_a? WasteExemptionsEngine::RenewingRegistration
          self.expires_on = transient_registration.registration.expires_on +
                            WasteExemptionsEngine.configuration.years_before_expiry.years
        else
          self.expires_on = Date.today + (WasteExemptionsEngine.configuration.years_before_expiry.years - 1.day)
        end

        save!
      end
      # rubocop:enable Style/ConditionalAssignment
    end
  end
end
