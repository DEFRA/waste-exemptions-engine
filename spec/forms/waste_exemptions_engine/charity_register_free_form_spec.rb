# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CharityRegisterFreeForm, type: :model do
    subject(:form) { build(:charity_register_free_form) }

    it "validates the form" do
      expect(form).to be_valid
    end
  end
end
