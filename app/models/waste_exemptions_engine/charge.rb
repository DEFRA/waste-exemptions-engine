# frozen_string_literal: true

module WasteExemptionsEngine
  class Charge < ApplicationRecord
    self.table_name = "charges"

    include CanConvertPenceToPounds
    pence_to_pounds_fields only: %i[charge_amount]

    enum :charge_type, { registration_charge: "registration_charge",
                        initial_compliance_charge: "initial_compliance_charge",
                        additional_compliance_charge: "additional_compliance_charge" }

    has_paper_trail

    belongs_to :chargeable, polymorphic: true

    validates :name, presence: true
    validates :charge_type, presence: true
    validates :charge_amount, presence: true, numericality: { only_integer: true }
  end
end
