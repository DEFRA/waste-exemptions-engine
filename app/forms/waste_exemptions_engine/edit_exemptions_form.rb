# frozen_string_literal: true

module WasteExemptionsEngine
  class EditExemptionsForm < BaseForm
    delegate :exemptions, to: :transient_registration
    delegate :registration, to: :transient_registration

    def submit(params)
      params[:exemption_ids] ||= []

      super
    end
  end
end
