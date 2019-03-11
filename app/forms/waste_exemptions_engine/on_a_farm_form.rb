# frozen_string_literal: true

module WasteExemptionsEngine
  class OnAFarmForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :on_a_farm

    def initialize(registration)
      super
      self.on_a_farm = @transient_registration.on_a_farm
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.on_a_farm = params[:on_a_farm]
      attributes = { on_a_farm: on_a_farm }

      super(attributes, params[:token])
    end

    validates :on_a_farm, "waste_exemptions_engine/yes_no": true
  end
end
