# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantEmailForm < BaseForm
    delegate :applicant_email, to: :transient_registration

    attr_writer :confirmed_email
    attr_accessor :no_email_address

    validates_with OptionalEmailFormValidator, attributes: [:applicant_email]

    def submit(params)
      # Blank email address values should be processed as nil
      params[:applicant_email] = nil if params[:applicant_email].blank?
      params[:confirmed_email] = nil if params[:confirmed_email].blank?
            
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.confirmed_email = params[:confirmed_email]
      self.no_email_address = params[:no_email_address]

      super(params.permit(:applicant_email))
    end

    def confirmed_email
      @confirmed_email || applicant_email
    end
  end
end
