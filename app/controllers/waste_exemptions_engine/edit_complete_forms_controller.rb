# frozen_string_literal: true

module WasteExemptionsEngine
  class EditCompleteFormsController < FormsController
    def new
      return unless super(EditCompleteForm, "edit_complete_form")

      # TODO: Edit completion service goes here
    end

    # Overwrite create and go_back as you shouldn't be able to submit or go back
    def create; end

    def go_back; end
  end
end
