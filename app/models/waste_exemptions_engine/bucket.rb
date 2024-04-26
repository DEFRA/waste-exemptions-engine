# frozen_string_literal: true

module WasteExemptionsEngine
  class Bucket < ApplicationRecord
    self.table_name = "buckets"

    has_paper_trail

    has_many :exemptions, through: :bucket_exemptions
  end
end
