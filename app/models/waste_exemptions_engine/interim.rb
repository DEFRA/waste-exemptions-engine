# frozen_string_literal: true

module WasteExemptionsEngine
  class Interim < ActiveRecord::Base
    belongs_to :enrollment

    self.table_name = "interims"
  end
end
