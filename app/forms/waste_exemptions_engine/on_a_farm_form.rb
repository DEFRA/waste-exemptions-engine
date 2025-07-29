# frozen_string_literal: true

module WasteExemptionsEngine
  class OnAFarmForm < BaseForm
    delegate :on_a_farm, to: :transient_registration

    validates :on_a_farm, "defra_ruby/validators/true_false": true

    def submit(attributes)
      # If the user is revisiting this form and previously said yes, there might
      # be a farm bucket which should now be removed if they said no this time around.
      if @transient_registration.respond_to?(:order) && attributes[:on_a_farm] == "false"
        @transient_registration.order&.update(bucket: nil)
      end

      super
    end
  end
end
