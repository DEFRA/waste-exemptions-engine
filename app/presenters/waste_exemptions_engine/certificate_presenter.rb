# frozen_string_literal: true

module WasteExemptionsEngine
  class CertificatePresenter < BasePresenter
    def partnership?
      business_type == "partnership"
    end

    def partners_names
      people.select(&:partner?).map do |person|
        format("%<first>s %<last>s", first: person.first_name, last: person.last_name)
      end.join("</br>").html_safe
    end

    def applicant_name
      format("%<first>s %<last>s", first: applicant_first_name, last: applicant_last_name)
    end

    def contact_name
      format("%<first>s %<last>s", first: contact_first_name, last: contact_last_name)
    end
  end
end
