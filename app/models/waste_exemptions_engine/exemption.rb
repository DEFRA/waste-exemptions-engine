# frozen_string_literal: true

module WasteExemptionsEngine
  class Exemption < ActiveRecord::Base

    self.table_name = "exemptions"

    has_many :registration_exemptions
    has_many :registrations, through: :registration_exemptions

    enum category: { using_waste: 0, treating_waste: 1, disposing_of_waste: 2, storing_waste: 3 }
  end
end
