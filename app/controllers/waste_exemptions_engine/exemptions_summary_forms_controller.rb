# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsSummaryFormsController < FormsController
    helper FinanceDetailsHelper
    def new
      super(ExemptionsSummaryForm, "exemptions_summary_form")
    end

    def create
      super(ExemptionsSummaryForm, "exemptions_summary_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:exemptions_summary_form, {}).permit(:exemptions)
    end
  end
end
