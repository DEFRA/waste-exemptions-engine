# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple progressing transition",
                      current_state: :contact_position_form,
                      next_state: :check_contact_phone_form,
                      factory: :new_registration
    end
  end
end
