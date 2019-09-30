# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPositionForm < BaseForm
    delegate :contact_position, to: :transient_registration

    validates :contact_position, "defra_ruby/validators/position": true

    def submit(params)
      attributes = { contact_position: params[:contact_position] }
      
      super(attributes)
    end
  end
end
