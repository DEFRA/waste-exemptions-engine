# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BackOfficeEditRegistration do
    describe "#workflow_state" do
      it_behaves_like "an address lookup transition",
                      next_state_if_not_skipping_to_manual: :back_office_edit_form,
                      address_type: "contact",
                      factory: :back_office_edit_registration
    end
  end
end
