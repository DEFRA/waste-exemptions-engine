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

    describe "edits_made?" do
      let(:edit_registration) { create(:edit_registration) }

      context "when the edit_registration has the same created_at and updated_at" do
        it "returns false" do
          expect(helper.edits_made?(edit_registration)).to eq(false)
        end
      end

      context "when the edit_registration has a different created_at and updated_at" do
        before { edit_registration.updated_at = edit_registration.created_at + 1.minute }

        it "returns true" do
          expect(helper.edits_made?(edit_registration)).to eq(true)
        end
      end
    end
  end
end
