# frozen_string_literal: true

module WasteExemptionsEngine
  module CanSetBusinessType
    extend ActiveSupport::Concern

    included do
      attr_accessor :business_type

      set_callback :initialize, :after, :set_business_type

      def set_business_type
        # We only use this for the correct microcopy
        self.business_type = @transient_registration.business_type
      end
    end
  end
end
