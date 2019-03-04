# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a final state", previous_state: :start_form, current_state: :contact_agency_form
    end
  end
end
