# frozen_string_literal: true

module WasteExemptionsEngine
  class EditForm < BaseForm
    attr_accessor :applicant_email
    attr_accessor :applicant_name
    attr_accessor :applicant_phone
    attr_accessor :business_type
    attr_accessor :company_no
    attr_accessor :contact_address
    attr_accessor :contact_email
    attr_accessor :contact_name
    attr_accessor :contact_phone
    attr_accessor :is_a_farmer
    attr_accessor :location
    attr_accessor :on_a_farm
    attr_accessor :operator_name
    attr_accessor :operator_address
    attr_accessor :people
    attr_accessor :reference
    attr_accessor :registration_exemptions
    attr_accessor :site_address

    # This form has a lot of attributes, so we have to disable the length cop.
    # rubocop:disable Metrics/MethodLength
    def initialize(registration)
      super
      self.applicant_email = @transient_registration.applicant_email
      self.applicant_name = full_name(@transient_registration.applicant_first_name,
                                      @transient_registration.applicant_last_name)
      self.applicant_phone = @transient_registration.applicant_phone
      self.business_type = @transient_registration.business_type
      self.company_no = @transient_registration.company_no
      self.contact_address = @transient_registration.contact_address
      self.contact_email = @transient_registration.contact_email
      self.contact_name = full_name(@transient_registration.contact_first_name,
                                    @transient_registration.contact_last_name)
      self.contact_phone = @transient_registration.contact_phone
      self.is_a_farmer = @transient_registration.is_a_farmer
      self.location = @transient_registration.location
      self.on_a_farm = @transient_registration.on_a_farm
      self.operator_name = @transient_registration.operator_name
      self.operator_address = @transient_registration.operator_address
      self.people = @transient_registration.people
      self.reference = @transient_registration.reference
      self.registration_exemptions = @transient_registration.registration_exemptions
      self.site_address = @transient_registration.site_address
    end
    # rubocop:enable Metrics/MethodLength

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      attributes = {}

      super(attributes, params[:token])
    end

    private

    def full_name(first_name, last_name)
      "#{first_name} #{last_name}"
    end
  end
end
