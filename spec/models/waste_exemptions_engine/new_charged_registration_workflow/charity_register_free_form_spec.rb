# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      it_behaves_like "a final state",
                      current_state: :charity_register_free_form,
                      factory: :new_charged_registration
    end
  end
end
