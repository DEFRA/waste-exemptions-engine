# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckYourAnswersForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :location
    attr_accessor :applicant_first_name, :applicant_last_name, :applicant_phone, :applicant_email
    attr_accessor :business_type, :company_no, :operator_name, :operator_address
    attr_accessor :contact_first_name, :contact_last_name, :contact_position, :contact_phone, :contact_email
    attr_accessor :contact_address
    attr_accessor :is_a_farm, :on_a_farm, :site_address, :grid_reference, :site_description, :exemptions

    # We know this is a long method, but its just assigning attributes. Breaking
    # it up for the sake of rubocop would add little benefit, hence the
    # exceptions
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def initialize(registration)
      super

      self.location = @transient_registration.location

      self.applicant_first_name = @transient_registration.applicant_first_name
      self.applicant_last_name = @transient_registration.applicant_last_name
      self.applicant_phone = @transient_registration.applicant_phone
      self.applicant_email = @transient_registration.applicant_email

      self.business_type = @transient_registration.business_type

      self.company_no = @transient_registration.company_no
      self.operator_name = @transient_registration.operator_name
      self.operator_address = @transient_registration.operator_address

      self.contact_first_name = @transient_registration.contact_first_name
      self.contact_last_name = @transient_registration.contact_last_name
      self.contact_position = @transient_registration.contact_position
      self.contact_phone = @transient_registration.contact_phone
      self.contact_email = @transient_registration.contact_email
      self.contact_address = @transient_registration.contact_address

      self.is_a_farm = @transient_registration.is_a_farm
      self.on_a_farm = @transient_registration.on_a_farm

      self.site_address = @transient_registration.site_address
      self.grid_reference = site_address&.grid_reference
      self.site_description = site_address&.description

      self.exemptions = @transient_registration.exemptions

      valid?
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

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
    validates :company_no, "waste_exemptions_engine/company_no": true
    validates :operator_name, "waste_exemptions_engine/operator_name": true
    validates :operator_address, "waste_exemptions_engine/address": true

    validates :contact_first_name, :contact_last_name, "waste_exemptions_engine/person_name": true
    validates :contact_position, "waste_exemptions_engine/position": true
    validates :contact_phone, "waste_exemptions_engine/phone_number": true
    validates :contact_email, "waste_exemptions_engine/email": true
    validates :contact_address, "waste_exemptions_engine/address": true

    validates :is_a_farm, inclusion: { in: [true, false] }
    validates :on_a_farm, inclusion: { in: [true, false] }
    validates :grid_reference, "waste_exemptions_engine/grid_reference": true
    validates :site_description, "waste_exemptions_engine/site_description": true
    validates :exemptions, "waste_exemptions_engine/exemptions": true

  end
end
