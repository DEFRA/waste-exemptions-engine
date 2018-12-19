# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorPostcodeForm < PostcodeForm
    include CanNavigateFlexibly

    attr_accessor :business_type, :operator_postcode

    def initialize(enrollment)
      super

      self.operator_postcode = @enrollment.interim.operator_postcode
      # We only use this for the correct microcopy
      self.business_type = @enrollment.business_type
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method
      # for updating
      self.operator_postcode = params[:operator_postcode]
      format_postcode(operator_postcode)
      attributes = {}

      # While we won't proceed if the postcode isn't valid, we should always
      # save it in case it's needed for manual entry
      @enrollment.interim.update_attributes(operator_postcode: operator_postcode)

      super(attributes, params[:token])
    end

    validates :operator_postcode, "waste_exemptions_engine/postcode": true
  end
end
