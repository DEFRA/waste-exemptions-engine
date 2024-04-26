# frozen_string_literal: true

module WasteExemptionsEngine
  class Band < ApplicationRecord
    self.table_name = "bands"

    has_paper_trail

    has_many :exemptions
  end
end
