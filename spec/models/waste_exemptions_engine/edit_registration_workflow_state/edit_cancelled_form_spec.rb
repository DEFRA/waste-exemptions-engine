# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a fixed final state",
                      current_state: :edit_cancelled_form,
                      factory: :edit_registration
    end
  end
end
