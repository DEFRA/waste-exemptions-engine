# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorNameForm < BaseForm
    delegate :business_type, :operator_name, to: :transient_registration

    validates :operator_name, "waste_exemptions_engine/operator_name": true

    def submit(params)
      attributes = { operator_name: params[:operator_name] }

      super(attributes)
    end
  end
end
