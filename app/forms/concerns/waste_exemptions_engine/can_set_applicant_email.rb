# frozen_string_literal: true

module WasteExemptionsEngine
  module CanSetApplicantEmail
    extend ActiveSupport::Concern

    included do
      attr_accessor :applicant_email

      set_callback :initialize, :after, :set_applicant_email

      def set_applicant_email
        self.applicant_email = @transient_registration.applicant_email
      end
    end
  end
end
