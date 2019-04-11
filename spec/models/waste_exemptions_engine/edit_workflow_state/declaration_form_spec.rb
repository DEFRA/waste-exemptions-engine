# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditedRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :edit_form,
                      current_state: :declaration_form,
                      next_state: :edit_complete_form,
                      factory: :edited_registration
    end
  end
end
