# frozen_string_literal: true

module WasteExemptionsEngine
  module PluralsHelper
    def confirmation_comms(form)
      if form.contact_email.present?
        "contact_email"
      else
        "letter"
      end
    end

    def exemptions_plural(form)
      form.exemptions.length > 1 ? "many" : "one"
    end
  end
end
