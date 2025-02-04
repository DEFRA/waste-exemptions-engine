# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ActivityExemptionsFormsHelper do
    describe "#selected_activity_exemptions" do
      let(:activity_one) { create(:waste_activity) }
      let(:activity_two) { create(:waste_activity) }
      let(:activity_three) { create(:waste_activity) }
      let(:transient_registration) { create(:new_charged_registration, temp_waste_activities:, temp_confirm_exemptions:) }
      let(:temp_waste_activities) { [activity_one.id, activity_two.id, activity_three.id] }
      let(:temp_confirm_exemptions) { true }
      let(:farmer_bucket) { create(:bucket) }
      let(:farming_exemptions) { create_list(:exemption, 2, waste_activity: activity_one) }
      let(:non_farming_exemptions) { create_list(:exemption, 2, waste_activity: activity_two) }

      before do
        allow(WasteExemptionsEngine::Bucket).to receive(:farmer_bucket).and_return(farmer_bucket)
        allow(farmer_bucket).to receive(:exemption_ids).and_return(farming_exemptions.map(&:id))

        # Actually create the exemptions in the database
        farming_exemptions
        non_farming_exemptions
      end

      context "when temp_confirm_exemptions is true" do
        let(:temp_confirm_exemptions) { true }

        it "returns all exemptions for selected waste activities", :aggregate_failures do
          exemptions = helper.selected_activity_exemptions(transient_registration)
          expect(exemptions).to include(*farming_exemptions)
          expect(exemptions).to include(*non_farming_exemptions)
        end
      end

      context "when temp_confirm_exemptions is false" do
        let(:temp_confirm_exemptions) { false }

        it "excludes farming bucket exemptions", :aggregate_failures do
          exemptions = helper.selected_activity_exemptions(transient_registration)
          expect(exemptions).not_to include(*farming_exemptions)
          expect(exemptions).to include(*non_farming_exemptions)
        end
      end

      context "when temp_confirm_exemptions is nil" do
        let(:temp_confirm_exemptions) { nil }

        it "returns all exemptions", :aggregate_failures do
          exemptions = helper.selected_activity_exemptions(transient_registration)
          expect(exemptions).to include(*farming_exemptions)
          expect(exemptions).to include(*non_farming_exemptions)
        end
      end

      context "when there is no farmer bucket" do
        before do
          allow(WasteExemptionsEngine::Bucket).to receive(:farmer_bucket).and_return(nil)
        end

        it "returns all exemptions regardless of temp_confirm_exemptions value", :aggregate_failures do
          [true, false, nil].each do |confirm_value|
            transient_registration.temp_confirm_exemptions = confirm_value
            exemptions = helper.selected_activity_exemptions(transient_registration)
            expect(exemptions).to include(*farming_exemptions)
            expect(exemptions).to include(*non_farming_exemptions)
          end
        end
      end
    end
  end
end
