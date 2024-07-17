# frozen_string_literal: true

module WasteExemptionsEngine
  class OrderCreationService < BaseService
    def run(transient_registration:)
      @transient_registration = transient_registration
      @order = transient_registration.create_order
      assign_exemptions
      assign_bucket

      @order
    end

    def assign_exemptions
      @transient_registration.transient_registration_exemptions.each do |transient_registration_exemption|
        @order.order_exemptions.create!(exemption_id: transient_registration_exemption.exemption_id)
      end
    end

    def assign_bucket
      return unless @transient_registration.farm_affiliated? && farmer_bucket.present?

      @order.create_order_bucket!(bucket: farmer_bucket)
    end

    def farmer_bucket
      @farmer_bucket ||= WasteExemptionsEngine::Bucket.find_by(name: I18n.t("waste_exemptions_engine.farmer_bucket",
                                                                            locale: :en))
    end
  end
end
