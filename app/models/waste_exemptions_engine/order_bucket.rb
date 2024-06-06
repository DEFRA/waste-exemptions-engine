# frozen_string_literal: true

module WasteExemptionsEngine
  class OrderBucket < ApplicationRecord
    self.table_name = "order_buckets"

    belongs_to :order
    belongs_to :bucket
  end
end
