# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BaseForm, type: :model do
    it "allows flexible navigation by default" do
      expect(BaseForm.can_navigate_flexibly?).to eq(true)
    end
  end
end
