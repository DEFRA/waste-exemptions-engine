# frozen_string_literal: true

module WasteExemptionsEngine
  class EnrollmentExemption < ActiveRecord::Base

    self.table_name = "enrollment_exemptions"

    belongs_to :enrollment
    belongs_to :exemption

  end
end
