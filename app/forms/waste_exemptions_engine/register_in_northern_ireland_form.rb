# frozen_string_literal: true

module WasteExemptionsEngine
  class RegisterInNorthernIrelandForm < BaseForm
    include CanNavigateFlexibly

    def initialize(transient_registration)
      super
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      attributes = {}

      super(attributes, params[:token])
    end
  end
end
