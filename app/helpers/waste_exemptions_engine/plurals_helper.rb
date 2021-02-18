# frozen_string_literal: true

module WasteExemptionsEngine
  module PluralsHelper
    def confirmation_comms(form)
      emails = [form.applicant_email, form.contact_email]
      emails.uniq!
      emails.delete(WasteExemptionsEngine.configuration.assisted_digital_email)

      if emails.empty?
        "letter"
      elsif emails == [form.contact_email]
        "contact_email"
      elsif emails == [form.applicant_email]
        "applicant_email"
      else
        "both_emails"
      end
    end

    def exemptions_plural(form)
      form.exemptions.length > 1 ? "many" : "one"
    end
  end
end
