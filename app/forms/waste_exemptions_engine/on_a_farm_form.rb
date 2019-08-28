# frozen_string_literal: true

module WasteExemptionsEngine
  class OnAFarmForm < BaseForm
    attr_accessor :on_a_farm

    validates :on_a_farm, "defra_ruby/validators/true_false": true

    def initialize(registration)
      super
      self.on_a_farm = @transient_registration.on_a_farm
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.on_a_farm = params[:on_a_farm]
      attributes = { on_a_farm: on_a_farm }

      super(attributes)
    end
  end
end
