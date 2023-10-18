# frozen_string_literal: true

module WasteExemptionsEngine
  module CanIterateExemptions
    extend ActiveSupport::Concern

    included do
      def sorted_active_registration_exemptions
        registration_exemptions_with_exemptions.where(state: "active").order(:exemption_id)
      end

      def sorted_deregistered_registration_exemptions
        registration_exemptions_with_exemptions.where("state != ?", "active").order_by_state_then_exemption_id
      end

      def registration_exemptions_with_exemptions
        registration_exemptions.includes(:exemption)
      end
    end
  end
end
