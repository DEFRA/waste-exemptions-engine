# frozen_string_literal: true

module WasteExemptionsEngine
  class Company < ApplicationRecord
    self.table_name = "companies"
    RECENTLY_UPDATED_LIMIT = 3.months.ago

    validates_uniqueness_of :company_no

    def self.find_or_create_by_company_no(company_no, name)
      company = find_or_initialize_by(company_no: company_no)
      company.name = name if company.new_record?
      company.save
      company
    end
  end
end
