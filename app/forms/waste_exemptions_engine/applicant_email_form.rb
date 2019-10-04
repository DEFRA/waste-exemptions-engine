# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantEmailForm < BaseForm
    delegate :applicant_email, to: :transient_registration

    attr_writer :confirmed_email

    validates :applicant_email, :confirmed_email, "defra_ruby/validators/email": true
    validates :confirmed_email, "waste_exemptions_engine/matching_email": { compare_to: :applicant_email }

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.confirmed_email = params[:confirmed_email]

      attributes = { applicant_email: params[:applicant_email] }

      super(attributes)
    end

    def confirmed_email
      @confirmed_email || applicant_email
    end
  end
end
