# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationNumberForm < BaseForm
    delegate :temp_company_no, :business_type, to: :transient_registration

    validates :temp_company_no, "defra_ruby/validators/companies_house_number": { permitted_types: %w[llp ltd] }

    def submit(params)
      params[:temp_company_no] = process_company_no(params[:temp_company_no])

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
