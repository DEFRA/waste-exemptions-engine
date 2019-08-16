# frozen_string_literal: true

module WasteExemptionsEngine
  class OnAFarmForm < BaseForm
    attr_accessor :on_a_farm

    set_callback :initialize, :after, :set_on_a_farm

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.on_a_farm = params[:on_a_farm]
      attributes = { on_a_farm: on_a_farm }

      super(attributes)
    end

    validates :on_a_farm, "defra_ruby/validators/true_false": true

    private

    def set_on_a_farm
      self.on_a_farm = @transient_registration.on_a_farm
    end
  end
end
