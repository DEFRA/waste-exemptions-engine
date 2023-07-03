# frozen_string_literal: true

module WasteExemptionsEngine
  module ExemptionsFormsHelper
    def all_exemptions
      Exemption.all.order(:id)
    end

    def all_visible_exemptions
      Exemption.visible.order(:id)
    end
  end
end
