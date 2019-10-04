# frozen_string_literal: true

module WasteExemptionsEngine
  class LocationForm < BaseForm
    delegate :location, to: :transient_registration

    validates :location, "defra_ruby/validators/location": true

    def submit(params)
      attributes = { location: params[:location] }

      super(attributes)
    end
  end
end
