# frozen_string_literal: true

module WasteExemptionsEngine
  class LocationForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :location

    def initialize(enrollment)
      super
      self.location = @enrollment.location
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.location = params[:location]
      attributes = { location: location }

      super(attributes, params[:id])
    end

    validates :location, "waste_exemptions_engine/location": true
  end
end
