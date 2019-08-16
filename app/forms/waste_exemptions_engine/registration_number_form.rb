# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationNumberForm < BaseForm
    include CanSetBusinessType

    attr_accessor :company_no

    set_callback :initialize, :after, :set_company_no

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      # If param isn't set, use a blank string instead to avoid errors with the validator
      self.company_no = params[:company_no] || ""
      self.company_no = process_company_no(company_no) if company_no.present?
      attributes = { company_no: company_no }

      super(attributes)
    end

    validates :company_no, "defra_ruby/validators/companies_house_number": true

    private

    def set_company_no
      self.company_no = @transient_registration.company_no
    end

    def process_company_no(company_no)
      number = company_no.to_s.strip
      # Should be 8 characters, so if it's not, add 0s to the start
      number = "0#{number}" while number.length < 8
      number.upcase
    end
  end
end
