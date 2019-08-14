# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPositionForm < BaseForm
    attr_accessor :position

    set_callback :initialize, :after, :set_contact_position

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.position = params[:position]
      attributes = { contact_position: position }

      super(attributes, params[:token])
    end

    validates :position, "waste_exemptions_engine/position": true

    private

    def set_contact_position
      self.position = @transient_registration.contact_position
    end
  end
end
