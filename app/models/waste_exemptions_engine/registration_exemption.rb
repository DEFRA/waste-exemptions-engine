# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationExemption < ActiveRecord::Base
    self.table_name = "registration_exemptions"

    belongs_to :registration
    belongs_to :exemption

    scope :active, -> { where(state: :active) }
    scope :order_by_exemption, -> { order(exemption_id: :asc) }
  end
end
