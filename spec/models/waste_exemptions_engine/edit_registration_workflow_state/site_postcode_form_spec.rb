# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditRegistration, type: :model do
    describe "#workflow_state" do
      it_behaves_like "a postcode transition",
                      previous_state: :edit_form,
                      address_type: "site",
                      factory: :edit_registration
    end
  end
end
