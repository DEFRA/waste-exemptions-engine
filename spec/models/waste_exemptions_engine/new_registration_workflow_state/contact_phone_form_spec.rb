# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :check_contact_phone_form,
                      current_state: :contact_phone_form,
                      next_state: :contact_email_form,
                      factory: :new_registration
    end
  end
end
