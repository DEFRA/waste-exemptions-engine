# frozen_string_literal: true

module WasteExemptionsEngine
  class BusinessTypeForm < BaseForm
    include CanSetBusinessType

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.business_type = params[:business_type]
      attributes = { business_type: business_type }

      super(attributes)
    end

    validates :business_type, "defra_ruby/validators/business_type": true
  end
end
