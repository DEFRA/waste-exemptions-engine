# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactNameForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :first_name, :last_name

    def initialize(enrollment)
      super
      self.first_name = @enrollment.contact_first_name
      self.last_name = @enrollment.contact_last_name
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.first_name = params[:first_name]
      self.last_name = params[:last_name]
      attributes = {
        contact_first_name: first_name,
        contact_last_name: last_name
      }

      super(attributes, params[:token])
    end

    validates :first_name, :last_name, "waste_exemptions_engine/person_name": true
  end
end
