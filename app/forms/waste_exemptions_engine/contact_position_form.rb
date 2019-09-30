# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPositionForm < BaseForm
    attr_accessor :contact_position

    validates :contact_position, "defra_ruby/validators/position": true

    def initialize(registration)
      super
      self.contact_position = @transient_registration.contact_position
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.contact_position = params[:contact_position]
      attributes = { contact_position: contact_position }

      super(attributes)
    end
  end
end
