# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckContactNameForm < BaseForm
    delegate :applicant_first_name, to: :transient_registration
    delegate :applicant_last_name, to: :transient_registration
    delegate :contact_first_name, to: :transient_registration
    delegate :contact_last_name, to: :transient_registration
    delegate :temp_reuse_applicant_name, to: :transient_registration

    validates :temp_reuse_applicant_name, "defra_ruby/validators/true_false": true

    def submit(params)
      if params[:temp_reuse_applicant_name] == "true"
        params[:contact_first_name] = applicant_first_name
        params[:contact_last_name] = applicant_last_name
      end

      super
    end
  end
end
