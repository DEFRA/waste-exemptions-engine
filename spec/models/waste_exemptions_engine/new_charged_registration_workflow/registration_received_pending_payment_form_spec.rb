# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewChargedRegistration do
    describe "#workflow_state" do
      it_behaves_like "a simple progressing transition",
                      current_state: :payment_summary_form,
                      next_state: :registration_received_pending_payment_form,
                      factory: :new_charged_registration_by_bank_transfer
    end
  end
end
