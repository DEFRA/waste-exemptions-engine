# frozen_string_literal: true

module WasteExemptionsEngine
  module CanSetExemptionsAndEmailsPlural
    extend ActiveSupport::Concern

    included do
      attr_accessor :exemptions_plural, :emails_plural

      set_callback :initialize, :after, :set_exemptions_plural
      set_callback :initialize, :after, :set_emails_plural

      def set_exemptions_plural
        self.exemptions_plural = @transient_registration.exemptions.length > 1 ? "many" : "one"
      end

      def set_emails_plural
        self.emails_plural = applicant_email == contact_email ? "one" : "many"
      end
    end
  end
end
