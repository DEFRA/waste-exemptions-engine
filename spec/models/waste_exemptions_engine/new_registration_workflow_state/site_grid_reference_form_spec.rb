# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    describe "#workflow_state" do
      subject(:transient_registration) { create(:new_registration, workflow_state: current_state) }
      it_behaves_like "site_grid_reference_form"
    end
  end
end
