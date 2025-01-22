# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmExemptionsForm < BaseForm
    delegate :temp_exemptions, to: :transient_registration

    def submit(params)
      attributes = { temp_exemptions: params[:temp_exemptions] }

      super(attributes)
    end
  end
end
