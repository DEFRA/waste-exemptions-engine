# frozen_string_literal: true

module WasteExemptionsEngine
  module CanChangeExemptionStatus
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :state do
        state :pending, initial: true
        state :active
        state :ceased
        state :expired
        state :revoked

        event :activate do
          transitions from: :pending,
                      to: :active,
                      after: :activate_exemption
        end

      end

      # Transition effects
      def activate_exemption
        self.registered_on = Date.today
        self.expires_on = Date.today + (Rails.configuration.years_before_expiry.years - 1.day)
        save!
      end
    end
  end
end
