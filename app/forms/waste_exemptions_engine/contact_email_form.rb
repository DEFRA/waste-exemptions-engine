# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactEmailForm < BaseForm
    attr_accessor :contact_email, :confirmed_email

    set_callback :initialize, :after, :set_contact_email
    set_callback :initialize, :after, :set_confirmed_email

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.contact_email = params[:contact_email]
      self.confirmed_email = params[:confirmed_email]

      attributes = { contact_email: contact_email }

      super(attributes, params[:token])
    end

    validates :contact_email, :confirmed_email, "waste_exemptions_engine/email": true
    validates :confirmed_email, "waste_exemptions_engine/matching_email": { compare_to: :contact_email }

    private

    def set_contact_email
      self.contact_email = @transient_registration.contact_email
    end

    def set_confirmed_email
      self.confirmed_email = @transient_registration.contact_email
    end
  end
end
