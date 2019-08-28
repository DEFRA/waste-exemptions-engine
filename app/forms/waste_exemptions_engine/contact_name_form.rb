# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactNameForm < BaseForm
    attr_accessor :contact_first_name, :contact_last_name

    validates :contact_first_name, :contact_last_name, "waste_exemptions_engine/person_name": true

    def initialize(registration)
      super
      self.contact_first_name = @transient_registration.contact_first_name
      self.contact_last_name = @transient_registration.contact_last_name
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.contact_first_name = params[:contact_first_name]
      self.contact_last_name = params[:contact_last_name]
      attributes = {
        contact_first_name: contact_first_name,
        contact_last_name: contact_last_name
      }

      super(attributes)
    end
  end
end
