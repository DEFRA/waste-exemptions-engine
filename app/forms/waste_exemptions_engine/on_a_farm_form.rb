# frozen_string_literal: true

module WasteExemptionsEngine
  class OnAFarmForm < BaseForm
    delegate :on_a_farm, to: :transient_registration

    validates :on_a_farm, "defra_ruby/validators/true_false": true

    def submit(params)
      attributes = { on_a_farm: params[:on_a_farm] }

      super(attributes)
    end
  end
end
