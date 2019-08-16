# frozen_string_literal: true

module WasteExemptionsEngine
  class LocationForm < BaseForm
    attr_accessor :location

    set_callback :initialize, :after, :set_location

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.location = params[:location]
      attributes = { location: location }

      super(attributes)
    end

    validates :location, "waste_exemptions_engine/location": true

    private

    def set_location
      self.location = @transient_registration.location
    end
  end
end
