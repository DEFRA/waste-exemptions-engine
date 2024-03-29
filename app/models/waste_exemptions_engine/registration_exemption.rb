# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationExemption < ApplicationRecord
    self.table_name = "registration_exemptions"

    include CanBeOrderedByStateAndExemptionId

    belongs_to :registration
    belongs_to :exemption

    scope :active, -> { where(state: :active) }
    scope :expired, -> { where(state: :expired) }
    scope :ceased, -> { where(state: :ceased) }
    scope :order_by_exemption, -> { order(exemption_id: :asc) }
  end
end
