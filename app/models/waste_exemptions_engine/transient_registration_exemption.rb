# frozen_string_literal: true

module WasteExemptionsEngine
  class TransientRegistrationExemption < ApplicationRecord
    self.table_name = "transient_registration_exemptions"

    include CanActivateExemption
    include CanBeOrderedByStateAndExemptionId

    belongs_to :transient_registration
    belongs_to :exemption

    scope :order_by_exemption, -> { order(exemption_id: :asc) }

    def exemption_attributes
      attributes.except("id", "transient_registration_id", "created_at", "updated_at")
    end
  end
end
