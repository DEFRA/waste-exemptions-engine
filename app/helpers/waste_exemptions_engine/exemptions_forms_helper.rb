# frozen_string_literal: true

module WasteExemptionsEngine
  module ExemptionsFormsHelper
    def all_exemptions
      Exemption.all.order(:id)
    end
  end
end

