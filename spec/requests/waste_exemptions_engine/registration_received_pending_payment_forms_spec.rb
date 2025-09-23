# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Received Pending Payment Forms" do
    let(:form) { build(:registration_received_pending_payment_form) }

    it_behaves_like "GET form", :registration_received_pending_payment_form, "/registration-received-pending-payment"
    it_behaves_like "unable to POST form", :registration_received_pending_payment_form, "/registration-received-pending-payment"
  end
end
