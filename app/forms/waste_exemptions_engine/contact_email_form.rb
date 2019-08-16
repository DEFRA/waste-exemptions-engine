# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactEmailForm < BaseForm

    attr_accessor :contact_email, :confirmed_email

    def initialize(registration)
      super
      self.contact_email = @transient_registration.contact_email
      self.confirmed_email = @transient_registration.contact_email
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.contact_email = params[:contact_email]
      self.confirmed_email = params[:confirmed_email]

      attributes = { contact_email: contact_email }

      super(attributes)
    end

    validates :contact_email, :confirmed_email, "defra_ruby/validators/email": true
    validates :confirmed_email, "waste_exemptions_engine/matching_email": { compare_to: :contact_email }
  end
end
