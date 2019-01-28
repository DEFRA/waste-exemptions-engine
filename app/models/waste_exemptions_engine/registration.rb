# frozen_string_literal: true

module WasteExemptionsEngine
  class Registration < ActiveRecord::Base
    include CanHaveRegistrationAttributes

    self.table_name = "registrations"

    has_many :addresses
    has_many :people
    has_many :registration_exemptions
    has_many :exemptions, through: :registration_exemptions

    scope :search_term, lambda { |term|
      where(
        "UPPER(applicant_email) = ?\
         OR UPPER(CONCAT(applicant_first_name, ' ', applicant_last_name)) LIKE ?\
         OR UPPER(contact_email) = ?\
         OR UPPER(CONCAT(contact_first_name, ' ', contact_last_name)) LIKE ?\
         OR UPPER(operator_name) LIKE ?\
         OR UPPER(reference) = ?",
        term&.upcase, # applicant_email
        "%#{term&.upcase}%", # applicant names
        term&.upcase, # contact_email
        "%#{term&.upcase}%", # contact names
        "%#{term&.upcase}%", # operator_name
        term&.upcase # reference
      )
    }

    scope :search_term_on_addresses, lambda { |term|
      joins(:addresses).merge(Address.search_term(term))
    }

    scope :search_term_on_people, lambda { |term|
      joins(:people).merge(Person.search_term(term))
    }

    private

    def find_address_by_type(address_type)
      return nil unless addresses.present?

      addresses.where(address_type: address_type).first
    end
  end
end
