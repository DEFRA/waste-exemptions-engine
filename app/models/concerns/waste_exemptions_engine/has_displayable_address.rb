# frozen_string_literal: true

module WasteExemptionsEngine
  module HasDisplayableAddress
    extend ActiveSupport::Concern

    included do
      def site_identifier
        if grid_reference.present?
          grid_reference
        else
          displayable_address_lines.join(", ")
        end
      end

      def displayable_address_lines
        [organisation, premises, street_address, locality, city, postcode].reject(&:blank?)
      end
    end
  end
end
