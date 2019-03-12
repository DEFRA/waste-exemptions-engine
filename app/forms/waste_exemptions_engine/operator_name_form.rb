# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorNameForm < BaseForm

    attr_accessor :business_type, :operator_name

    def initialize(registration)
      super
      # We only use this for the correct microcopy
      self.business_type = @transient_registration.business_type
      self.operator_name = @transient_registration.operator_name
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.operator_name = params[:operator_name]
      attributes = { operator_name: operator_name }

      super(attributes, params[:token])
    end

    validates :operator_name, "waste_exemptions_engine/operator_name": true
  end
end
