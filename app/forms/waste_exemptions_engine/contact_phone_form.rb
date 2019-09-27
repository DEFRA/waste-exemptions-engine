# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPhoneForm < BaseForm
    attr_accessor :contact_phone

    validates :contact_phone, "defra_ruby/validators/phone_number": true

    def submit(params)
      attributes = { contact_phone: params[:contact_phone] }

      super(attributes)
    end
  end
end
