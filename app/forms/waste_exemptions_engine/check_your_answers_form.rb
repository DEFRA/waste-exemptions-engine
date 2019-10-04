# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckYourAnswersForm < BaseForm
    include DataOverviewForm

    validates :location, "defra_ruby/validators/location": true
    validates :applicant_first_name, :applicant_last_name, "waste_exemptions_engine/person_name": true
    validates :applicant_phone, "defra_ruby/validators/phone_number": true
    validates :applicant_email, "defra_ruby/validators/email": true

    validates :business_type, "defra_ruby/validators/business_type": true
    validates :company_no, "defra_ruby/validators/companies_house_number": true, if: :company_no_required?
    validates :operator_name, "waste_exemptions_engine/operator_name": true
    validates :operator_address, "waste_exemptions_engine/address": true

    validates :contact_first_name, :contact_last_name, "waste_exemptions_engine/person_name": true
    validates :contact_position, "defra_ruby/validators/position": true
    validates :contact_phone, "defra_ruby/validators/phone_number": true
    validates :contact_email, "defra_ruby/validators/email": true
    validates :contact_address, "waste_exemptions_engine/address": true

    validates :on_a_farm, inclusion: { in: [true, false] }
    validates :is_a_farmer, inclusion: { in: [true, false] }
    validates :exemptions, "waste_exemptions_engine/exemptions": true

    validates :grid_reference, "defra_ruby/validators/grid_reference": true, if: :uses_site_location?
    validates :description, "waste_exemptions_engine/site_description": true, if: :uses_site_location?
    validates :site_address, "waste_exemptions_engine/address": true, unless: :uses_site_location?

    after_initialize :valid

    def submit(_params)
      super({})
    end

    private

    def company_no_required?
      @transient_registration.company_no_required?
    end

    # https://api.rubyonrails.org/classes/ActiveModel/Callbacks.html
    # `method_name` passed to #define_model_callbacks must not end with !, ? or =.
    def valid
      valid?
    end

    def uses_site_location?
      # This should never happen, but if there is no site address we default
      # to validating the site grid reference and description
      return true unless transient_registration&.site_address

      transient_registration.site_address.auto?
    end
  end
end
