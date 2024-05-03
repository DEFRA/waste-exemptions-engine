module WasteExemptionsEngine
  class Charge < ApplicationRecord
    self.table_name = "charges"

    include CanConvertPenceToPounds
    pence_to_pounds_fields only: %i[charge_amount]

    enum charge_type: { registration_charge: :registration_charge, compliance_charge: :compliance_charge }

    has_paper_trail

    validates :name, presence: true, uniqueness: true
    validates :charge_type, presence: true
    validates :charge_amount, presence: true, numericality: { only_integer: true }
  end
end
