# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactNameForm < BaseForm
    delegate :contact_first_name, :contact_last_name, to: :transient_registration

    validates :contact_first_name, :contact_last_name, "waste_exemptions_engine/person_name": true
  end
end
