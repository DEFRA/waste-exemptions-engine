# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantNameForm < BaseForm
    delegate :applicant_first_name, :applicant_last_name, to: :transient_registration

    validates :applicant_first_name, :applicant_last_name, "waste_exemptions_engine/person_name": true
  end
end
