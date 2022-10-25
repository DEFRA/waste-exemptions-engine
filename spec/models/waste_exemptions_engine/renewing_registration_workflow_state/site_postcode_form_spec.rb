# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration do
    describe "#workflow_state" do
      it_behaves_like "a postcode transition",
                      address_type: "site",
                      factory: :renewing_registration

      it_behaves_like "a postcode transition",
                      address_type: "site",
                      factory: :renewing_registration_with_manual_site_address
    end
  end
end
