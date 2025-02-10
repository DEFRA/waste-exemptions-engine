# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmActivityExemptionsForm < BaseForm
    delegate :exemption_ids, :temp_exemptions, :temp_farm_exemptions, :temp_confirm_exemptions, :farm_affiliated?,
             to: :transient_registration
    delegate :temp_add_additional_non_farm_exemptions, to: :transient_registration

    validates :temp_confirm_exemptions, "defra_ruby/validators/true_false": true

    def initialize(transient_registration)
      transient_registration.temp_confirm_exemptions = nil

      super
    end

    def submit(params)
      params.merge!(exemption_ids: temp_exemptions) if params[:temp_confirm_exemptions] == "true"

      super
    end
  end
end
