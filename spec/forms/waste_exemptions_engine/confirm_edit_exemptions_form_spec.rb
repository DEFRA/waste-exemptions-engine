# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmEditExemptionsForm, type: :model do
    it "is a BaseForm" do
      expect(described_class.superclass).to eq(BaseForm)
    end
  end
end
