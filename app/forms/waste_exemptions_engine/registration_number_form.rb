# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationNumberForm < BaseForm
    delegate :company_no, :business_type, to: :transient_registration

    validates :company_no, "defra_ruby/validators/companies_house_number": true

    def submit(params)
      params[:company_no] = process_company_no(params[:company_no])

      super
    end

    private

    def process_company_no(company_no)
      return unless company_no.present?

      number = company_no.to_s.strip
      # Should be 8 characters, so if it's not, add 0s to the start
      number = "0#{number}" while number.length < 8
      number.upcase
    end
  end
end
