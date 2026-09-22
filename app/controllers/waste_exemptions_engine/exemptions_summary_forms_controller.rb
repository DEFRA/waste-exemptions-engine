# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsSummaryFormsController < FormsController
    helper FinanceDetailsHelper
    def new
      return unless super(ExemptionsSummaryForm, "exemptions_summary_form")

      redirect_to new_start_form_path unless registration_data_present?
    end

    def create
      super(ExemptionsSummaryForm, "exemptions_summary_form")
    end

    private

    def registration_data_present?
      @transient_registration.exemptions.exists? && @transient_registration.site_addresses.exists?
    end

    def transient_registration_attributes
      params.fetch(:exemptions_summary_form, {}).permit(:exemptions)
    end
  end
end
