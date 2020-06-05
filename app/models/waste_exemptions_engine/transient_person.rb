# frozen_string_literal: true

module WasteExemptionsEngine
  class TransientPerson < ApplicationRecord

    self.table_name = "transient_people"

    belongs_to :transient_registration

    enum person_type: { partner: 0 }

    def person_attributes
      attributes.except("id", "transient_registration_id", "created_at", "updated_at")
    end
  end
end
