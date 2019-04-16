# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :business_type_form,
                      current_state: :registration_number_form,
                      next_state: :operator_name_form,
                      factory: :new_registration
    end
  end
end
