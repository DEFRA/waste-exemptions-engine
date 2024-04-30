# frozen_string_literal: true

module WasteExemptionsEngine
  class BucketExemption < ApplicationRecord
    self.table_name = "bucket_exemptions"

    belongs_to :bucket
    belongs_to :exemption
  end
end
