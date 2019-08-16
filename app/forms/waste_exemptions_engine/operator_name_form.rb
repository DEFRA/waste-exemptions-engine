# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorNameForm < BaseForm
    include CanSetBusinessType

    attr_accessor :operator_name

    set_callback :initialize, :after, :set_operator_name

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.operator_name = params[:operator_name]
      attributes = { operator_name: operator_name }

      super(attributes)
    end

    validates :operator_name, "waste_exemptions_engine/operator_name": true

    private

    def set_operator_name
      self.operator_name = @transient_registration.operator_name
    end
  end
end
