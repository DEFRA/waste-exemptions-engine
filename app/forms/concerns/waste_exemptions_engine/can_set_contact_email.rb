# frozen_string_literal: true

module WasteExemptionsEngine
  module CanSetContactEmail
    extend ActiveSupport::Concern

    included do
      attr_accessor :contact_email

      set_callback :initialize, :after, :set_contact_email

      def set_contact_email
        self.contact_email = @transient_registration.contact_email
      end
    end
  end
end
