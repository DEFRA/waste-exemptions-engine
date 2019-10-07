# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPhoneForm < BaseForm
    delegate :contact_phone, to: :transient_registration

    validates :contact_phone, "defra_ruby/validators/phone_number": true
  end
end
