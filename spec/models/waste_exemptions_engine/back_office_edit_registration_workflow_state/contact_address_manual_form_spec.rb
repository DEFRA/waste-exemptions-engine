# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BackOfficeEditRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      current_state: :contact_address_manual_form,
                      next_state: :back_office_edit_form,
                      factory: :back_office_edit_registration
    end
  end
end
