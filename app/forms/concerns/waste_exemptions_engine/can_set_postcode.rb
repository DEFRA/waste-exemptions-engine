# frozen_string_literal: true

module WasteExemptionsEngine
  module CanSetPostcode
    extend ActiveSupport::Concern

    included do
      attr_accessor :postcode

      set_callback :initialize, :after, :set_postcode

      def set_postcode
        self.postcode = existing_postcode
      end
    end
  end
end
