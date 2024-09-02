# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do
    describe "#workflow_state" do
      before { registration.temp_check_your_answers_flow = true }

      it_behaves_like "an address lookup transition",
                      next_state_if_not_skipping_to_manual: :renewal_start_form,
                      address_type: "contact",
                      factory: :renewing_registration
    end
  end
end
