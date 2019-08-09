# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationExemption < ActiveRecord::Base
    self.table_name = "registration_exemptions"

    belongs_to :registration
    belongs_to :exemption

    scope :active, -> { where(state: :active) }
    scope :order_by_exemption, -> { order(exemption_id: :asc) }

    def too_late_to_renew?
      last_renewable_date = expires_on + WasteExemptionsEngine.configuration.registration_renewal_grace_window.days
      Date.current > last_renewable_date
    end
  end
end
