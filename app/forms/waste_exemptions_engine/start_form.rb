# frozen_string_literal: true

module WasteExemptionsEngine
  class StartForm < BaseForm
    delegate :start_option

    validates :start_option, "waste_exemptions_engine/start": true

    def submit(params)
      attributes = { start_option: params[:start_option] }

      super(attributes)
    end
  end
end
