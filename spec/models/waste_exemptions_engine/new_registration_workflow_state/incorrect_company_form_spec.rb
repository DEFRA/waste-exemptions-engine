# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      current_state: :incorrect_company_form,
                      next_state: :registration_number_form,
                      factory: :new_registration
    end
  end
end
