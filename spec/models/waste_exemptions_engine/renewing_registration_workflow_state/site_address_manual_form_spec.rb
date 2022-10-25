# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple bidirectional transition",
                      current_state: :site_address_manual_form,
                      next_state: :check_your_answers_form,
                      factory: :renewing_registration
    end
  end
end
