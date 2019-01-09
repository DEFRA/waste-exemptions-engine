# frozen_string_literal: true

module WasteExemptionsEngine
  class KeyPerson < ActiveRecord::Base

    self.table_name = "key_people"

    belongs_to :registration

    enum person_type: { partner: 0 }

  end
end
