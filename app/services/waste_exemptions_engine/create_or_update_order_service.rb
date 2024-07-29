# frozen_string_literal: true

module WasteExemptionsEngine
  class CreateOrUpdateOrderService < BaseService
    def run(transient_registration:)
      @transient_registration = transient_registration
      @order = transient_registration.order || transient_registration.create_order
      assign_exemptions
      assign_bucket
      @order
    end

    private

    def assign_exemptions
      @order.order_exemptions.destroy_all
      @transient_registration.exemptions.each do |exemption|
        @order.order_exemptions.create!(exemption: exemption)
      end
    end

    def assign_bucket
      return unless @transient_registration.farm_affiliated? && farmer_bucket.present?

      @order.create_order_bucket!(bucket: farmer_bucket)
    end

    def farmer_bucket
      @farmer_bucket ||= WasteExemptionsEngine::Bucket.farmer_bucket
    end
  end
end
