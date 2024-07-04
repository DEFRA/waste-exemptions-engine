# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do
    describe "#workflow_state" do
      subject(:transient_registration) { create(:renewing_registration, workflow_state: :site_grid_reference_form) }
      it_behaves_like "site_grid_reference_form"
    end
  end
end
