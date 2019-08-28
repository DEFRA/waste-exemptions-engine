# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantNameForm < BaseForm
    attr_accessor :applicant_first_name, :applicant_last_name

    validates :applicant_first_name, :applicant_last_name, "waste_exemptions_engine/person_name": true

    def initialize(registration)
      super
      self.applicant_first_name = @transient_registration.applicant_first_name
      self.applicant_last_name = @transient_registration.applicant_last_name
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.applicant_first_name = params[:applicant_first_name]
      self.applicant_last_name = params[:applicant_last_name]

      attributes = {
        applicant_first_name: applicant_first_name,
        applicant_last_name: applicant_last_name
      }

      super(attributes)
    end
  end
end
