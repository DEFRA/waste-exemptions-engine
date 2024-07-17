# frozen_string_literal: true

module WasteExemptionsEngine
  class Order < ApplicationRecord

    self.table_name = "orders"

    belongs_to :orderable, polymorphic: true
    has_many :order_exemptions, dependent: :destroy
    has_many :exemptions, through: :order_exemptions

    has_one :order_bucket, dependent: :destroy
    has_one :bucket, through: :order_bucket

    def highest_band
      return nil if exemptions.empty?

      exemptions.max_by { |exemption| exemption.band.initial_compliance_charge.charge_amount }.band
    end

    def bucket?
      bucket.present?
    end

    def bands
      exemptions.map(&:band).uniq
    end
  end
end
