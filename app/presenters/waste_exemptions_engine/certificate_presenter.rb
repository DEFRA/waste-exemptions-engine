# frozen_string_literal: true

module WasteExemptionsEngine
  class CertificatePresenter < BasePresenter

    LOCALES_KEY = ".waste_exemptions_engine.pdfs.certificate"

    # By complex we mean is there a need to display extra detail in the
    # document. If its a partnership we display we display an extra section,
    # which is a list of their names.
    def complex_organisation_details?
      return false unless %w[partnership].include?(business_type)

      true
    end

    # The certificate displays headings on the left, and values from the
    # registration on the right. Because this heading is dynamic based on the
    # business type, we have a method for it in the presenter
    def complex_organisation_heading
      return I18n.t("#{LOCALES_KEY}.operator.partners") if business_type == "partnership"

      I18n.t("#{LOCALES_KEY}.operator.business_name_if_applicable")
    end

    def complex_organisation_name
      return operator_name unless business_type == "partnership"

      # Based on the logic found in the existing certificate, we simply display
      # the company name field unless its a partnership, in which case we list
      # out all the partners
      list_people
    end

    def expires_after_pluralized
      ActionController::Base.helpers.pluralize(
        WasteExemptionsEngine.configuration.years_before_expiry,
        I18n.t("#{LOCALES_KEY}.changes.year")
      )
    end

    def site_is_grid_reference?
      site_address.auto?
    end

    def list_people
      list = people
             .select(&:partner?)
             .map { |person| format("%<first>s %<last>s", first: person.first_name, last: person.last_name) }
      list.join("<br>").html_safe
    end

  end
end
