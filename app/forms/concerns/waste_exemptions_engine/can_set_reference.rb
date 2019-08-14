# frozen_string_literal: true

module WasteExemptionsEngine
  module CanSetReference
    extend ActiveSupport::Concern

    included do
      attr_accessor :reference

      set_callback :initialize, :after, :set_reference

      def set_reference
        self.reference = @transient_registration.reference
      end
    end
  end
end
