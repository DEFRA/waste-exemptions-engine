# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewalStopForm, type: :model do
    describe ".can_navigate_flexibly?" do
      it "returns true" do
        expect(described_class).to be_can_navigate_flexibly
      end
    end
  end
end
