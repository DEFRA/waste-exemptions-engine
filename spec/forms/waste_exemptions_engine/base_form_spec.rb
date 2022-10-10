# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BaseForm, type: :model do
    it "allows flexible navigation by default" do
      expect(described_class.can_navigate_flexibly?).to be(true)
    end
  end
end
