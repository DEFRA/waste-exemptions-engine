# frozen_string_literal: true

module WasteExemptionsEngine
  module RegistrationCompleteFormsHelper
    def exemptions_plural(transient_registration)
      transient_registration.exemptions.length > 1 ? "many" : "one"
    end
  end
end
