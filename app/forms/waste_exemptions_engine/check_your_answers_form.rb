# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckYourAnswersForm < BaseForm

    attr_accessor :location
    attr_accessor :applicant_first_name, :applicant_last_name, :applicant_phone, :applicant_email
    attr_accessor :business_type, :company_no, :operator_name, :people, :operator_address
    attr_accessor :contact_first_name, :contact_last_name, :contact_position, :contact_phone, :contact_email
    attr_accessor :contact_address
    attr_accessor :on_a_farm, :is_a_farmer, :site_address, :grid_reference, :site_description, :exemptions

    def initialize(registration)
      super
      assign_attributes_to_display
      valid?
    end

    def submit(params)
      super({}, params[:token])
    end

    def applicant_name
      "#{applicant_first_name} #{applicant_last_name}"
    end

    def contact_name
      "#{contact_first_name} #{contact_last_name}"
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

    # We know this is a long method, but it's just assigning attributes. Breaking
    # it up for the sake of Rubocop would add little benefit, hence the exceptions
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def assign_attributes_to_display
      self.location = @transient_registration.location

      self.applicant_first_name = @transient_registration.applicant_first_name
      self.applicant_last_name = @transient_registration.applicant_last_name
      self.applicant_phone = @transient_registration.applicant_phone
      self.applicant_email = @transient_registration.applicant_email

      self.business_type = @transient_registration.business_type

      self.company_no = @transient_registration.company_no
      self.operator_name = @transient_registration.operator_name
      self.people = @transient_registration.people
      self.operator_address = @transient_registration.operator_address

      self.contact_first_name = @transient_registration.contact_first_name
      self.contact_last_name = @transient_registration.contact_last_name
      self.contact_position = @transient_registration.contact_position
      self.contact_phone = @transient_registration.contact_phone
      self.contact_email = @transient_registration.contact_email
      self.contact_address = @transient_registration.contact_address

      self.on_a_farm = @transient_registration.on_a_farm
      self.is_a_farmer = @transient_registration.is_a_farmer

      self.site_address = @transient_registration.site_address
      self.grid_reference = site_address&.grid_reference
      self.site_description = site_address&.description

      self.exemptions = @transient_registration.exemptions
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

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
