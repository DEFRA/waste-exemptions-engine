# frozen_string_literal: true

module WasteExemptionsEngine
  class StartForm < BaseForm
    attr_accessor :start

    set_callback :initialize, :after, :set_start

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.start = params[:start]
      attributes = { start_option: start }

      super(attributes, params[:token])
    end

    validates :start, "waste_exemptions_engine/start": true

    private

    def set_start
      self.start = @transient_registration.start_option
    end
  end
end
