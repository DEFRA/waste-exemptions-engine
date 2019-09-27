# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactNameForm < BaseForm
    delegate :contact_first_name, :contact_last_name, to: :transient_registration

    validates :contact_first_name, :contact_last_name, "waste_exemptions_engine/person_name": true

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      attributes = {
        contact_first_name: params[:contact_first_name],
        contact_last_name: params[:contact_last_name]
      }

      super(attributes)
    end
  end
end
