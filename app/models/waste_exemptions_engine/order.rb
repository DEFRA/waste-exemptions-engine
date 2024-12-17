# frozen_string_literal: true

module WasteExemptionsEngine
  class Order < ApplicationRecord
    self.table_name = "orders"

    delegate :total_charge_amount, to: :charge_detail

    belongs_to :order_owner, polymorphic: true
    has_many :order_exemptions, dependent: :destroy
    has_many :exemptions, through: :order_exemptions, after_add: :reset_charge_detail

    has_one :order_bucket, dependent: :destroy
    has_one :bucket, through: :order_bucket
    has_one :charge_detail, dependent: :destroy

    after_initialize :generate_order_uuid

    def highest_band
      return nil if exemptions.empty?

      exemptions.max_by { |exemption| exemption.band.initial_compliance_charge.charge_amount }.band
    end

    def bucket?
      bucket.present?
    end

    def order_calculator
      WasteExemptionsEngine::OrderCalculatorService.new(self)
    end

    private

    def reset_charge_detail(exemption)
      charge_detail.band_charge_details = order_calculator.band_charge_details if exemption && charge_detail.present?
    end

    def generate_order_uuid
      self.order_uuid ||= SecureRandom.uuid
    end
  end
end
