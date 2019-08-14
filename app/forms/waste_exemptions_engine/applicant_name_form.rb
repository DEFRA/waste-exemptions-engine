# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantNameForm < BaseForm

    attr_accessor :first_name, :last_name

    set_callback :initialize, :after, :set_first_name
    set_callback :initialize, :after, :set_last_name

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

    private

    def set_first_name
      self.first_name = @transient_registration.applicant_first_name
    end

    def set_last_name
      self.last_name = @transient_registration.applicant_last_name
    end
  end
end
