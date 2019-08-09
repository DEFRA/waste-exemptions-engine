# frozen_string_literal: true

module WasteExemptionsEngine
  module DataOverviewForm
    attr_accessor :location
    attr_accessor :applicant_first_name, :applicant_last_name, :applicant_phone, :applicant_email
    attr_accessor :business_type, :company_no, :operator_name, :people, :operator_address
    attr_accessor :contact_first_name, :contact_last_name, :contact_position, :contact_phone, :contact_email
    attr_accessor :contact_address
    attr_accessor :on_a_farm, :is_a_farmer, :site_address, :grid_reference, :site_description, :exemptions

    def applicant_name
      "#{applicant_first_name} #{applicant_last_name}"
    end

    def contact_name
      "#{contact_first_name} #{contact_last_name}"
    end

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

      self.exemptions = @transient_registration.exemptions.order_by_exemption
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
