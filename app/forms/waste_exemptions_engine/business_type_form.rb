# frozen_string_literal: true

module WasteExemptionsEngine
  class BusinessTypeForm < BaseForm
    delegate :business_type, to: :transient_registration

    validates :business_type, "defra_ruby/validators/business_type": true

    private

    def transient_registration_attributes(params)
      {
        business_type: params[:business_type]
      }
    end
  end
end
