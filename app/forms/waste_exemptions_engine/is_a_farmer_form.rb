# frozen_string_literal: true

module WasteExemptionsEngine
  class IsAFarmerForm < BaseForm
    delegate :is_a_farmer, to: :transient_registration

    validates :is_a_farmer, "defra_ruby/validators/true_false": true

    def submit(attributes)
      # If the user is revisiting this form and previously said yes, there might
      # be a farm bucket which should now be removed if they said no this time around.
      if @transient_registration.respond_to?(:order) && attributes[:is_a_farmer] == "false"
        @transient_registration.order&.update(bucket: nil)
      end

      super
    end
  end
end
