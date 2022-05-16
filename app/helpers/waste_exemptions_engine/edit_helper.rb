# frozen_string_literal: true

module WasteExemptionsEngine
  module EditHelper
    LOCALE = "waste_exemptions_engine.edit_forms"

    def edit_back_path(_edit_registration)
      "/"
    end

    def edit_finished_path(_edit_registration)
      "/"
    end

    def edits_made?(edit_registration)
      edit_registration.updated_at != edit_registration.created_at
    end

    def entity_name_label(edit_registration)
      if edit_registration.llp_or_ltd?
        t("new.sections.operator.labels.operator_name", scope: LOCALE)
      else
        t("new.sections.operator.labels.name", scope: LOCALE)
      end
    end
  end
end
