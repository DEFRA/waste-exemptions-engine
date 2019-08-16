# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckYourAnswersForm < BaseForm
    include DataOverviewForm

    def initialize(registration)
      super
      assign_attributes_to_display
      valid?
    end

    def submit(_params)
      super({})
    end

    validates :location, "waste_exemptions_engine/location": true
    validates :applicant_first_name, :applicant_last_name, "waste_exemptions_engine/person_name": true
    validates :applicant_phone, "waste_exemptions_engine/phone_number": true
    validates :applicant_email, "waste_exemptions_engine/email": true

    validates :business_type, "waste_exemptions_engine/business_type": true
    validates :company_no, "defra_ruby/validators/companies_house_number": true, if: :company_no_required?
    validates :operator_name, "waste_exemptions_engine/operator_name": true
    validates :operator_address, "waste_exemptions_engine/address": true

    validates :contact_first_name, :contact_last_name, "waste_exemptions_engine/person_name": true
    validates :contact_position, "waste_exemptions_engine/position": true
    validates :contact_phone, "waste_exemptions_engine/phone_number": true
    validates :contact_email, "waste_exemptions_engine/email": true
    validates :contact_address, "waste_exemptions_engine/address": true

    validates :on_a_farm, inclusion: { in: [true, false] }
    validates :is_a_farmer, inclusion: { in: [true, false] }
    validates :exemptions, "waste_exemptions_engine/exemptions": true

    validates :grid_reference, "waste_exemptions_engine/grid_reference": true, if: :uses_site_location?
    validates :site_description, "waste_exemptions_engine/site_description": true, if: :uses_site_location?
    validates :site_address, "waste_exemptions_engine/address": true, unless: :uses_site_location?

    private

    def company_no_required?
      @transient_registration.company_no_required?
    end

    def uses_site_location?
      # This should never happen, but if there is no site address we default
      # to validating the site grid reference and description
      return true unless @transient_registration&.site_address

      @transient_registration.site_address.auto?
    end
  end
end
