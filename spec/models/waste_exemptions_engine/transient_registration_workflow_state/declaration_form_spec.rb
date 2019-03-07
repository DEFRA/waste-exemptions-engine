# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :check_your_answers_form,
                      current_state: :declaration_form,
                      next_state: :registration_complete_form
    end
  end
end
