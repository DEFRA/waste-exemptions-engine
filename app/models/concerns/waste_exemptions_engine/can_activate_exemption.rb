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

      # Transition effects
      def activate_exemption
        self.registered_on = Date.today

        self.expires_on = if transient_registration.is_a? WasteExemptionsEngine::RenewingRegistration
                            puts ">>> activate_exemption for WasteExemptionsEngine::RenewingRegistration"
                            transient_registration.registration.expires_on +
                              WasteExemptionsEngine.configuration.years_before_expiry.years
                          else
                            puts ">>> activate_exemption for WasteExemptionsEngine::Registration"
                            Date.today + (WasteExemptionsEngine.configuration.years_before_expiry.years - 1.day)
                          end
        save!
      end
    end
  end
end
