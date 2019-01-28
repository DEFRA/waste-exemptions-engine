# frozen_string_literal: true

module WasteExemptionsEngine
  class Person < ActiveRecord::Base

    self.table_name = "people"

    belongs_to :registration

    enum person_type: { partner: 0 }

    scope :search_term, lambda { |term|
      where("UPPER(CONCAT(first_name, ' ', last_name)) LIKE ?", "%#{term&.upcase}%")
    }
  end
end
