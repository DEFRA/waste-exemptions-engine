# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalCompleteForm < RegistrationCompleteForm
    attr_accessor :expire_month_year
  end
end
