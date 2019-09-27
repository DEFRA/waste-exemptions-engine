# frozen_string_literal: true

module WasteExemptionsEngine
  class EditForm < BaseForm
    delegate :applicant_email, :applicant_first_name, :applicant_last_name, to: :transient_registration
    delegate :applicant_phone, :business_type, :company_no, :contact_address, to: :transient_registration
    delegate :contact_email, :contact_first_name, :contact_last_name, :contact_phone, to: :transient_registration
    delegate :is_a_farmer, :location, :on_a_farm, :operator_name, :operator_address, to: :transient_registration
    delegate :people, :reference, :registration_exemptions, :site_address, to: :transient_registration

    def initialize(registration)
      registration.save! unless registration.persisted?

      super
    end

    def submit(_params)
      super({})
    end
  end
end
