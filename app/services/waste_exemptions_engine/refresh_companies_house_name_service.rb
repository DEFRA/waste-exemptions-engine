# frozen_string_literal: true

require "defra_ruby_companies_house"

module WasteExemptionsEngine
  class RefreshCompaniesHouseNameService < WasteExemptionsEngine::BaseService
    def run(company_reference)
      registration = Registration.find_by(reference: company_reference)
      company_name = DefraRubyCompaniesHouse.new(registration.company_no).company_name
      registration.operator_name = company_name
      registration.companies_house_updated_at = Time.current
      registration.save!

      true
    end
  end
end
