# frozen_string_literal: true

module WasteExemptionsEngine
  module EditHelper
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
      if edit_registration.company_no_required?
        t(".sections.operator.labels.operator_name")
      else
        t(".sections.operator.labels.name")
      end
    end

    def exemptions_list(edit_registration)
      edit_registration.exemptions.pluck(:code).join(", ")
    end
  end
end
