# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FrontOfficeEditCompleteNoChangesForm, type: :model do
    describe ".can_navigate_flexibly?" do
      it "returns false" do
        expect(described_class).not_to be_can_navigate_flexibly
      end
    end
  end
end
