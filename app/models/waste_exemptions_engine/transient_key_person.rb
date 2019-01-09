# frozen_string_literal: true

module WasteExemptionsEngine
  class TransientKeyPerson < ActiveRecord::Base

    self.table_name = "transient_key_people"

    belongs_to :transient_registration

    enum person_type: { partner: 0 }

    def key_person_attributes
      attributes.except("id", "transient_registration_id", "created_at", "updated_at")
    end
  end
end
