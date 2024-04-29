# frozen_string_literal: true

module WasteExemptionsEngine
  class Band < ApplicationRecord
    self.table_name = "bands"

    has_paper_trail

    has_many :exemptions

    validates :name, presence: true
    validates :sequence, uniqueness: true, numericality: { only_integer: true }, allow_nil: true
    validates :registration_fee, numericality: { only_integer: true }, allow_nil: true
    validates :initial_compliance_charge, numericality: { only_integer: true }, allow_nil: true
    validates :additional_compliance_charge, numericality: { only_integer: true }, allow_nil: true
  end
end
