# frozen_string_literal: true

module WasteExemptionsEngine
  class StartForm < BaseForm
    attr_accessor :start_option

    validates :start_option, "waste_exemptions_engine/start": true

    def initialize(registration)
      super
      self.start_option = @transient_registration.start_option
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.start_option = params[:start_option]
      attributes = { start_option: start_option }

      super(attributes)
    end
  end
end
