# frozen_string_literal: true

module WasteExemptionsEngine
  class Payment < ApplicationRecord

    self.table_name = "payments"

    belongs_to :order
  end
end
