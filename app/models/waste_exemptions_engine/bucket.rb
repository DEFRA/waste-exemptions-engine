# frozen_string_literal: true

module WasteExemptionsEngine
  class Bucket < ApplicationRecord
    self.table_name = "buckets"
    has_paper_trail

    enum :bucket_type, {
      farmer: "farmer",
      charity: "charity"
    }

    validates :bucket_type, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true

    has_many :bucket_exemptions, dependent: :destroy
    has_many :exemptions, through: :bucket_exemptions
    has_one :initial_compliance_charge, lambda {
      where(charge_type: :initial_compliance_charge)
    }, class_name: "WasteExemptionsEngine::Charge", as: :chargeable

    accepts_nested_attributes_for :initial_compliance_charge
    validates_associated :initial_compliance_charge, numericality: { only_integer: true }

    def self.farmer_bucket
      find_by(bucket_type: "farmer")
    end

    def exemption_ids
      exemptions.pluck(:id).map(&:to_s)
    end
  end
end
