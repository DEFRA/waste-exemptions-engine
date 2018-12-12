# frozen_string_literal: true

module WasteExemptionsEngine
  class BusinessTypeForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :business_type

    def initialize(enrollment)
      super
      self.business_type = @enrollment.business_type
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.business_type = params[:business_type]
      attributes = { business_type: business_type }

      super(attributes, params[:token])
    end

    validates :business_type, "waste_exemptions_engine/business_type": true
  end
end
