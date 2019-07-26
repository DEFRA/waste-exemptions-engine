# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewWithChangesFormsController < FormsController
    def new
      super(RenewWithChangesForm, "renew_with_changes_form")
    end

    def create
      super(RenewWithChangesForm, "renew_with_changes_form")
    end
  end
end
