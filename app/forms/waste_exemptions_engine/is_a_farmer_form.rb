# frozen_string_literal: true

module WasteExemptionsEngine
  class IsAFarmerForm < BaseForm
    attr_accessor :is_a_farmer

    set_callback :initialize, :after, :set_is_a_farmer

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.is_a_farmer = params[:is_a_farmer]
      attributes = { is_a_farmer: is_a_farmer }

      super(attributes)
    end

    validates :is_a_farmer, "defra_ruby/validators/true_false": true

    private

    def set_is_a_farmer
      self.is_a_farmer = @transient_registration.is_a_farmer
    end
  end
end
