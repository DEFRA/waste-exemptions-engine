# frozen_string_literal: true

module WasteExemptionsEngine
  class OrderExemption < ApplicationRecord
    self.table_name = "order_exemptions"

    belongs_to :order
    belongs_to :exemption
  end
end
