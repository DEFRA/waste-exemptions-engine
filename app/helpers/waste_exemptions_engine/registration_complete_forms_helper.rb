# frozen_string_literal: true

module WasteExemptionsEngine
  module RegistrationCompleteFormsHelper
    def exemptions_plural(form)
      form.exemptions.length > 1 ? "many" : "one"
    end
  end
end
