# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantPhoneForm < BaseForm
    delegate :applicant_phone, to: :transient_registration

    validates :applicant_phone, "defra_ruby/validators/phone_number": true
  end
end
