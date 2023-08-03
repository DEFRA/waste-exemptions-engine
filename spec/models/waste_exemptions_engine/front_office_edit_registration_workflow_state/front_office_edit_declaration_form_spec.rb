# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FrontOfficeEditRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      current_state: :front_office_edit_declaration_form,
                      next_state: :front_office_edit_complete_no_change_form,
                      factory: :front_office_edit_registration
    end
  end
end
