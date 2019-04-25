# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditHelper, type: :helper do
    describe "edit_back_path" do
      it "returns the correct value" do
        expect(helper.edit_back_path(build(:edit_registration))).to eq("/")
      end
    end

    describe "edit_finished_path" do
      it "returns the correct value" do
        expect(helper.edit_finished_path(build(:edit_registration))).to eq("/")
      end
    end
  end
end
