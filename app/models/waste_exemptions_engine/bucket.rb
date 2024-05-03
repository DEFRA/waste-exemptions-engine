# frozen_string_literal: true

module WasteExemptionsEngine
  class Bucket < ApplicationRecord
    self.table_name = "buckets"

    has_paper_trail

    has_many :exemptions, through: :bucket_exemptions

    has_one :initial_compliance_charge, -> { where(charge_type: :initial_compliance_charge) }, class_name: "WasteExemptionsEngine::Charge", as: :chargeable

    validates :name, presence: true, uniqueness: true

    accepts_nested_attributes_for :initial_compliance_charge
    validates_associated :initial_compliance_charge, numericality: { only_integer: true }
  end
end
