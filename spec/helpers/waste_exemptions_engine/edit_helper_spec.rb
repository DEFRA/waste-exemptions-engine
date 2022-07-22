# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditHelper, type: :helper do
    before { helper.instance_variable_set(:@virtual_path, "waste_exemptions_engine.edit_forms.new") }

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

    describe "entity_name_label" do
      let(:edit_registration) { create(:edit_registration, business_type: business_type) }
      let(:result) { helper.entity_name_label(edit_registration) }

      context "when business type is llp" do
        let(:business_type) { "limitedLiabilityPartnership" }

        it { expect(result).to eq("Registered name") }
      end

      context "when business type is ltd" do
        let(:business_type) { "limitedLiabilityPartnership" }

        it { expect(result).to eq("Registered name") }
      end

      context "when business type is anything else" do
        %w[soleTrader partnership localAuthority charity].each do |type|
          let(:business_type) { type }

          it { expect(helper.entity_name_label(edit_registration)).to eq("Name") }
        end
      end
    end
  end
end
