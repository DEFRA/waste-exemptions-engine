# frozen_string_literal: true

module WasteExemptionsEngine
  class Bucket < ApplicationRecord
    self.table_name = "buckets"

    has_paper_trail

    has_many :exemptions, through: :bucket_exemptions

    validates :name, presence: true
    validates :charge_amount, numericality: { only_integer: true }, allow_nil: true
  end
end
