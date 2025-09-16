# frozen_string_literal: true

module WasteExemptionsEngine
  class MultisiteExemptionsSummaryFormsController < FormsController
    helper FinanceDetailsHelper
    def new
      super(MultisiteExemptionsSummaryForm, "multisite_exemptions_summary_form")
    end

    def create
      super(MultisiteExemptionsSummaryForm, "multisite_exemptions_summary_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:multisite_exemptions_summary_form, {}).permit(:exemptions)
    end
  end
end
