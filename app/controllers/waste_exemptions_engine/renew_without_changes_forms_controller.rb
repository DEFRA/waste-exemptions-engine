# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewWithoutChangesFormsController < FormsController
    def new
      super(RenewWithoutChangesForm, "renew_without_changes_form")
    end

    def create
      super(RenewWithoutChangesForm, "renew_without_changes_form")
    end
  end
end
