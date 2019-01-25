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
      where("reference = ?", term&.upcase)
    }

    private

    def find_address_by_type(address_type)
      return nil unless addresses.present?

      addresses.where(address_type: address_type).first
    end
  end
end
