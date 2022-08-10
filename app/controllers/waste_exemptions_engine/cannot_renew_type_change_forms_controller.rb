# frozen_string_literal: true

module WasteExemptionsEngine
  class CannotRenewTypeChangeFormsController < FormsController
    include CannotSubmitForm

    def new
      super(CannotRenewTypeChangeForm, "cannot_renew_type_change_form")
    end
  end
end
