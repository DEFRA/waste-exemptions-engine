# frozen_string_literal: true

module WasteExemptionsEngine
  class CertificatePresenter < BasePresenter
    def partnership?
      business_type == "Partnership"
    end

    def partners_names
      people.select(&:partner?).map do |person|
        format_name(first: person.first_name, last: person.last_name)
      end.join("</br>").html_safe
    end

    def applicant_name
      format_name(first: applicant_first_name, last: applicant_last_name)
    end

    def business_type
      I18n.t("waste_exemptions_engine.pdfs.certificate.busness_types.#{super}")
    end

    def contact_name
      format_name(first: contact_first_name, last: contact_last_name)
    end

    private

    def format_name(names)
      format("%<first>s %<last>s", names)
    end
  end
end
