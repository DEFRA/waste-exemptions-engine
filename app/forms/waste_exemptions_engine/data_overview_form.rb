# frozen_string_literal: true

module WasteExemptionsEngine
  module DataOverviewForm
    delegate :location, :applicant_first_name, :applicant_last_name, to: :transient_registration
    delegate :contact_first_name, :applicant_phone, :applicant_email, to: :transient_registration
    delegate :business_type, :company_no, :operator_name, :people, :operator_address, to: :transient_registration
    delegate :contact_last_name, :contact_position, :contact_phone, :contact_email, to: :transient_registration
    delegate :contact_address, to: :transient_registration
    delegate :on_a_farm, :is_a_farmer, :site_address, to: :transient_registration
    delegate :site_address, to: :transient_registration
    delegate :grid_reference, :site_description, to: :site_address, allow_nil: true
    delegate :exemptions, to: :transient_registration

    def registration_exemptions
      @registration_exemptions ||= ordered_exemptions
    end

    def should_have_company_no?
      transient_registration.company_no_required?
    end

    def should_have_partners?
      transient_registration.partnership?
    end

    def ordered_exemptions
      transient_registration.registration_exemptions.includes(:exemption).order_by_exemption
    end
  end
end
