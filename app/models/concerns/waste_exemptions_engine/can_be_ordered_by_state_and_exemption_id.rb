# frozen_string_literal: true

module WasteExemptionsEngine
  module CanBeOrderedByStateAndExemptionId
    extend ActiveSupport::Concern

    included do
      scope :order_by_state_then_exemption_id, lambda {
        order(
          Arel.sql(
            "CASE
              WHEN state = 'active'  THEN '1'
              WHEN state = 'ceased'  THEN '2'
              WHEN state = 'revoked' THEN '3'
              WHEN state = 'expired' THEN '4'
            END"
          ),
          :exemption_id
        )
      }
    end
  end
end
