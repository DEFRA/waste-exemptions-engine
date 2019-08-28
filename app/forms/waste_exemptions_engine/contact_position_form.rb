# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPositionForm < BaseForm
    attr_accessor :position

    validates :position, "defra_ruby/validators/position": true

    def initialize(registration)
      super
      self.position = @transient_registration.contact_position
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.position = params[:position]
      attributes = { contact_position: position }

      super(attributes)
    end
  end
end
