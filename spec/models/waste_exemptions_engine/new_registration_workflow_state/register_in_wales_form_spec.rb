# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    describe "#workflow_state" do
      it_behaves_like "a final state",
                      current_state: :register_in_wales_form,
                      factory: :new_registration
    end
  end
end
