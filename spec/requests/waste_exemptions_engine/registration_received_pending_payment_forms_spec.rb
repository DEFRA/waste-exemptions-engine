# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Received Pending Payment Forms" do
    let(:form) { build(:registration_received_pending_payment_form) }

    include_examples "GET form", :registration_received_pending_payment_form, "/registration-received-pending-payment"
    include_examples "unable to POST form", :registration_received_pending_payment_form, "/registration-received-pending-payment"
  end
end
