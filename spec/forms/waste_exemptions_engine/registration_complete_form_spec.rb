# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationCompleteForm, type: :model do
    describe ".can_navigate_flexibly?" do
      it "returns false" do
        expect(described_class.can_navigate_flexibly?).to be_falsey
      end
    end
  end
end
