# frozen_string_literal: true

module WasteExemptionsEngine
  class CertificatePresenter < BasePresenter

    include WasteExemptionsEngine::CanIterateExemptions

    def partners_names
      people.map do |person|
        format_name(person.first_name, person.last_name)
      end.join("</br>").html_safe
    end

    def human_business_type
      I18n.t("waste_exemptions_engine.pdfs.certificate.business_types.#{business_type}")
    end

    def contact_name
      format_name(contact_first_name, contact_last_name)
    end

    def unique_active_registration_exemptions
      seen = Set.new
      sorted_active_registration_exemptions.select { |re| seen.add?(re.exemption_id) }
    end

    def deregistered_exemptions_for_site(address)
      address.registration_exemptions.includes(:exemption)
             .where(state: %i[ceased revoked])
             .order_by_state_then_exemption_id
    end

    def expiry_date
      expires_on&.to_formatted_s(:day_month_year)
    end

    def ceased_or_revoked_on(registration_exemption)
      case registration_exemption.state
      when "revoked"
        I18n.t("waste_exemptions_engine.exemptions.revoked_on",
               date: registration_exemption.deregistered_at&.to_formatted_s(:day_month_year))
      when "ceased"
        I18n.t("waste_exemptions_engine.exemptions.ceased_on",
               date: registration_exemption.deregistered_at&.to_formatted_s(:day_month_year))
      else
        ""
      end
    end

    private

    def format_name(first_name, last_name)
      "#{first_name} #{last_name}"
    end
  end
end
