# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantEmailForm < BaseForm
    include CanSetApplicantEmail

    attr_accessor :confirmed_email

    set_callback :initialize, :after, :set_confirmed_email

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.applicant_email = params[:applicant_email]
      self.confirmed_email = params[:confirmed_email]

      attributes = { applicant_email: applicant_email }

      super(attributes)
    end

    validates :applicant_email, :confirmed_email, "waste_exemptions_engine/email": true
    validates :confirmed_email, "waste_exemptions_engine/matching_email": { compare_to: :applicant_email }

    private

    def set_confirmed_email
      self.confirmed_email = @transient_registration.applicant_email
    end
  end
end
