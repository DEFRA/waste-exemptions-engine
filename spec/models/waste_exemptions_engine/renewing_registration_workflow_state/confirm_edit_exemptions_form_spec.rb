# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do
    describe "#workflow_state" do
      # temp_confirm_exemption_edits defaults to nil, so this should
      # go back to the edit page and not to the declaration page
      it_behaves_like "a simple progressing transition",
                      current_state: :confirm_edit_exemptions_form,
                      next_state: :edit_exemptions_form,
                      factory: :renewing_registration
    end
  end
end
