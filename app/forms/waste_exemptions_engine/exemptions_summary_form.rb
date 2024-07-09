# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsSummaryForm < BaseForm
    delegate :exemptions, to: :transient_registration
  end
end
