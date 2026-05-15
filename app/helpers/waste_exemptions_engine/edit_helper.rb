# frozen_string_literal: true

module WasteExemptionsEngine
  module EditHelper
    def exemptions_list(edit_registration)
      edit_registration.exemptions.pluck(:code).join(", ")
    end
  end
end
