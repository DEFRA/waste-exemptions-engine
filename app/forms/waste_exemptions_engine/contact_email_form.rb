# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactEmailForm < BaseForm
    delegate :contact_email, to: :transient_registration

    attr_writer :confirmed_email

    validates :contact_email, :confirmed_email, "defra_ruby/validators/email": true
    validates :confirmed_email, "waste_exemptions_engine/matching_email": { compare_to: :contact_email }

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.confirmed_email = params[:confirmed_email]

      attributes = { contact_email: params[:contact_email] }

      super(attributes)
    end

    def confirmed_email
      @confirmed_email || contact_email
    end
  end
end
