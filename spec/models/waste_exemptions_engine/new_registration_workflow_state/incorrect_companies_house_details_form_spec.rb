# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :check_registered_name_and_address_form,
                      current_state: :incorrect_companies_house_details_form,
                      next_state: :registration_number_form,
                      factory: :new_registration
    end
  end
end
