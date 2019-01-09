# frozen_string_literal: true

module WasteExemptionsEngine
  class IsAFarmForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :is_a_farm

    def initialize(registration)
      super
      self.is_a_farm = @transient_registration.is_a_farm
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.is_a_farm = params[:is_a_farm]
      attributes = { is_a_farm: is_a_farm }

      super(attributes, params[:token])
    end

    validates :is_a_farm, "waste_exemptions_engine/yes_no": true
  end
end
