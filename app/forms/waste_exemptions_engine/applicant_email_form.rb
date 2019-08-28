# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantEmailForm < BaseForm
    attr_accessor :applicant_email
    attr_writer :confirmed_email

    validates :applicant_email, :confirmed_email, "defra_ruby/validators/email": true
    validates :confirmed_email, "waste_exemptions_engine/matching_email": { compare_to: :applicant_email }

    def initialize(registration)
      super
      self.applicant_email = @transient_registration.applicant_email
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.applicant_email = params[:applicant_email]
      @confirmed_email = params[:confirmed_email]

      attributes = { applicant_email: applicant_email }

      super(attributes)
    end

    def confirmed_email
      @confirmed_email ||= transient_registration.applicant_email
    end
  end
end
