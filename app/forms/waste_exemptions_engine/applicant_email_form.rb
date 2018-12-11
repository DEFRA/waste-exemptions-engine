# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantEmailForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :contact_email, :confirmed_email

    def initialize(enrollment)
      super
      self.contact_email = @enrollment.applicant_email
      self.confirmed_email = @enrollment.applicant_email
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.contact_email = params[:contact_email]
      self.confirmed_email = params[:confirmed_email]

      attributes = { applicant_email: contact_email }

      super(attributes, params[:id])
    end

    validates :contact_email, :confirmed_email, "waste_exemptions_engine/email": true
    validates :confirmed_email, "waste_exemptions_engine/matching_email": { compare_to: :contact_email }
  end
end
