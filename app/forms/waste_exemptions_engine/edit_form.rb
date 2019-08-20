# frozen_string_literal: true

module WasteExemptionsEngine
  class EditForm < BaseForm
    delegate :applicant_email, :applicant_phone, :business_type, :company_no, to: :transient_registration
    delegate :contact_phone, :contact_email, :is_a_farmer, :location, :on_a_farm, to: :transient_registration
    delegate :operator_name, :operator_address, :people, :reference, to: :transient_registration
    delegate :contact_address, :registration_exemptions, :site_address, :applicant_name, to: :transient_registration
    delegate :contact_name, to: :transient_registration

    def initialize(registration)
      registration.save! unless registration.persisted?

      super
    end

    private

    def full_name(first_name, last_name)
      "#{first_name} #{last_name}"
    end
  end
end
