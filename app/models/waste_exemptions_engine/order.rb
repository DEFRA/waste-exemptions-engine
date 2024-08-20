# frozen_string_literal: true

module WasteExemptionsEngine
  class Order < ApplicationRecord
    self.table_name = "orders"

    delegate :total_charge_amount, to: :charge_detail

    belongs_to :order_owner, polymorphic: true
    has_many :order_exemptions, dependent: :destroy
    has_many :exemptions, through: :order_exemptions

    has_one :order_bucket, dependent: :destroy
    has_one :bucket, through: :order_bucket
    has_one :charge_detail, dependent: :destroy
    has_one :payment

    def highest_band
      return nil if exemptions.empty?

      exemptions.max_by { |exemption| exemption.band.initial_compliance_charge.charge_amount }.band
    end

    def bucket?
      bucket.present?
    end

    # Generate a uuid for the this order, on demand
    def order_uuid
      update(order_uuid: SecureRandom.uuid) unless self[:order_uuid]

      self[:order_uuid]
    end

    def order_calculator
      WasteExemptionsEngine::OrderCalculatorService.new(self)
    end
  end
end
