# frozen_string_literal: true

module WasteExemptionsEngine
  module PluralsHelper
    def emails_plural(form)
      form.applicant_email == form.contact_email ? "one" : "many"
    end

    def exemptions_plural(form)
      form.exemptions.length > 1 ? "many" : "one"
    end
  end
end
