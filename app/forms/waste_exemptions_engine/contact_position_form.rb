# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPositionForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :position

    def initialize(registration)
      super
      self.position = @transient_registration.contact_position
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.position = params[:position]
      attributes = { contact_position: position }

      super(attributes, params[:token])
    end

    validates :position, "waste_exemptions_engine/position": true
  end
end
