# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantNameForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :first_name, :last_name

    def initialize(registration)
      super
      self.first_name = @registration.applicant_first_name
      self.last_name = @registration.applicant_last_name
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.first_name = params[:first_name]
      self.last_name = params[:last_name]
      attributes = {
        applicant_first_name: first_name,
        applicant_last_name: last_name
      }

      super(attributes, params[:token])
    end

    validates :first_name, :last_name, "waste_exemptions_engine/person_name": true
  end
end
