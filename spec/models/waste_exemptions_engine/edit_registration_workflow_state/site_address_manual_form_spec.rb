# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :site_postcode_form,
                      current_state: :site_address_manual_form,
                      next_state: :edit_form,
                      factory: :edit_registration
    end
  end
end
