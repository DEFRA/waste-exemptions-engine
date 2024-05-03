# frozen_string_literal: true

module WasteExemptionsEngine
  class Band < ApplicationRecord
    self.table_name = "bands"

    has_paper_trail

    has_many :exemptions

    has_one :initial_compliance_charge, -> { where(charge_type: :initial_compliance_charge) }, class_name: "WasteExemptionsEngine::Charge", as: :chargeable
    has_one :additional_compliance_charge, -> { where(charge_type: :additional_compliance_charge) }, class_name: "WasteExemptionsEngine::Charge", as: :chargeable

    validates :name, presence: true, uniqueness: true
    validates :sequence, uniqueness: true, numericality: { only_integer: true }, allow_nil: true

    accepts_nested_attributes_for :initial_compliance_charge
    accepts_nested_attributes_for :additional_compliance_charge

    validates_associated :initial_compliance_charge, numericality: { only_integer: true }
    validates_associated :additional_compliance_charge, numericality: { only_integer: true }
  end
end
