# frozen_string_literal: true

module WasteExemptionsEngine
  class Person < ApplicationRecord

    self.table_name = "people"

    belongs_to :registration
  end
end
