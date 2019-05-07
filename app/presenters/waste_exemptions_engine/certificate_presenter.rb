# frozen_string_literal: true

module WasteExemptionsEngine
  class CertificatePresenter < BasePresenter
    def partnership?
      business_type == "Partnership"
    end

    def partners_names
      people.select(&:partner?).map do |person|
        format_name(person.first_name, person.last_name)
      end.join("</br>").html_safe
    end

    def applicant_name
      format_name(applicant_first_name, applicant_last_name)
    end

    def human_business_type
      I18n.t("waste_exemptions_engine.pdfs.certificate.busness_types.#{super}")
    end

    def contact_name
      format_name(contact_first_name, contact_last_name)
    end

    private

    def format_name(first_name, last_name)
      "#{first_name} #{last_name}"
    end
  end
end
