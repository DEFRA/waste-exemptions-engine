# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmFarmExemptionsForm < BaseForm
    delegate :exemption_ids,
             :temp_exemptions,
             :temp_farm_exemptions,
             :temp_add_additional_non_farm_exemptions,
             to: :transient_registration

    validates :temp_add_additional_non_farm_exemptions, "defra_ruby/validators/true_false": true

    def initialize(transient_registration)
      transient_registration.temp_add_additional_non_farm_exemptions = nil

      super
    end

    def submit(params)
      params.merge!(exemption_ids: temp_farm_exemptions) if params[:temp_add_additional_non_farm_exemptions] == "false"

      super
    end
  end
end
