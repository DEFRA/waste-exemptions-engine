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

    def name_label(edit_registration)
      if %w[limitedCompany limitedLiabilityPartnership].include?(edit_registration.business_type)
        "Registered name"
      else
        "Name"
      end
    end
  end
end
