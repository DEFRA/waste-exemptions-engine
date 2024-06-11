# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckContactEmailForm < BaseForm
    delegate :applicant_email, to: :transient_registration
    delegate :contact_email, to: :transient_registration
    delegate :temp_reuse_applicant_email, to: :transient_registration

    validates :temp_reuse_applicant_email, "defra_ruby/validators/true_false": true

    def submit(params)
      params[:contact_email] = applicant_email if params[:temp_reuse_applicant_email] == "true"
      super
    end
  end
end
