# frozen_string_literal: true

module WasteExemptionsEngine
  class CaptureEmailForm < BaseForm

    attr_accessor :reference, :contact_email

    validates_with DefraRuby::Validators::EmailValidator, attributes: [:contact_email]

    def submit(params)
      self.contact_email = params[:contact_email]

      super(params.permit(:reference, :contact_email))
    end
  end
end
