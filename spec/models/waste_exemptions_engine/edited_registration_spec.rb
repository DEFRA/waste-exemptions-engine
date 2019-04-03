# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditedRegistration, type: :model do
    subject(:edited_registration) { create(:edited_registration) }

    it "subclasses TransientRegistration" do
      expect(described_class).to be < TransientRegistration
    end
  end
end
