# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactEmailForm < BaseForm
    delegate :contact_email, to: :transient_registration

    attr_writer :confirmed_email
    attr_accessor :no_email_address

    validates_with OptionalEmailFormValidator, attributes: [:contact_email]

    def submit(params)
      # Blank email address values should be processed as nil
      params[:contact_email] = nil if params[:contact_email].blank?
      params[:confirmed_email] = nil if params[:confirmed_email].blank?

      # Assign the params for validation and pass them to the BaseForm method for updating
      self.confirmed_email = params[:confirmed_email]
      self.no_email_address = params[:no_email_address]

      super(params.permit(:contact_email))
    end

    def confirmed_email
      @confirmed_email || contact_email
    end
  end
end
