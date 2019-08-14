# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactNameForm < BaseForm
    attr_accessor :first_name, :last_name

    set_callback :initialize, :after, :set_contact_first_name
    set_callback :initialize, :after, :set_contact_last_name

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.first_name = params[:first_name]
      self.last_name = params[:last_name]
      attributes = {
        contact_first_name: first_name,
        contact_last_name: last_name
      }

      super(attributes, params[:token])
    end

    validates :first_name, :last_name, "waste_exemptions_engine/person_name": true

    private

    def set_contact_first_name
      self.first_name = @transient_registration.contact_first_name
    end

    def set_contact_last_name
      self.last_name = @transient_registration.contact_last_name
    end
  end
end
