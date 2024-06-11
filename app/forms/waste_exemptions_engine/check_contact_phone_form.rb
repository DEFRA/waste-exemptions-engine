# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckContactPhoneForm < BaseForm
    delegate :applicant_phone, to: :transient_registration
    delegate :contact_phone, to: :transient_registration
    delegate :temp_reuse_applicant_phone, to: :transient_registration

    validates :temp_reuse_applicant_phone, "defra_ruby/validators/true_false": true

    def submit(params)
      params[:contact_phone] = applicant_phone if params[:temp_reuse_applicant_phone] == "true"
      super
    end
  end
end
