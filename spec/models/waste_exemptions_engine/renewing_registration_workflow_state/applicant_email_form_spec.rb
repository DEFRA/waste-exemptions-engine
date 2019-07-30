# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      previous_state: :applicant_phone_form,
                      current_state: :applicant_email_form,
                      next_state: :business_type_form,
                      factory: :renewing_registration
    end
  end
end
