# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ActivityExemptionsFormsHelper do
    describe "#selected_activity_exemptions" do
      let(:activity_one) { create(:waste_activity) }
      let(:activity_two) { create(:waste_activity) }
      let(:activity_three) { create(:waste_activity) }
      let(:transient_registration) { create(:new_charged_registration, temp_waste_activities:, temp_add_additional_non_bucket_exemptions:) }
      let(:temp_waste_activities) { [activity_one.id, activity_two.id, activity_three.id] }
      let(:temp_add_additional_non_bucket_exemptions) { true }
      let(:farmer_bucket) { create(:bucket) }
      let(:farming_exemptions) { create_list(:exemption, 2, waste_activity: activity_one) }
      let(:non_farming_exemptions) { create_list(:exemption, 2, waste_activity: activity_two) }

      before do
        allow(WasteExemptionsEngine::Bucket).to receive(:farmer_bucket).and_return(farmer_bucket)
        allow(farmer_bucket).to receive(:exemption_ids).and_return(farming_exemptions.map(&:id))
        allow(transient_registration).to receive(:farm_affiliated?).and_return(true)

        # Actually create the exemptions in the database
        farming_exemptions
        non_farming_exemptions
      end

      context "when user is farm affiliated" do
        before { allow(transient_registration).to receive(:farm_affiliated?).and_return(true) }

        context "when temp_add_additional_non_bucket_exemptions is true" do
          let(:temp_add_additional_non_bucket_exemptions) { true }

          it "excludes farming bucket exemptions", :aggregate_failures do
            exemptions = helper.selected_activity_exemptions(transient_registration)
            expect(exemptions).not_to include(*farming_exemptions)
            expect(exemptions).to include(*non_farming_exemptions)
          end
        end

        context "when temp_add_additional_non_bucket_exemptions is false" do
          let(:temp_add_additional_non_bucket_exemptions) { false }

          it "returns all exemptions for selected waste activities", :aggregate_failures do
            exemptions = helper.selected_activity_exemptions(transient_registration)
            expect(exemptions).to include(*farming_exemptions)
            expect(exemptions).to include(*non_farming_exemptions)
          end
        end

        context "when temp_add_additional_non_bucket_exemptions is nil" do
          let(:temp_add_additional_non_bucket_exemptions) { nil }

          it "returns all exemptions", :aggregate_failures do
            exemptions = helper.selected_activity_exemptions(transient_registration)
            expect(exemptions).to include(*farming_exemptions)
            expect(exemptions).to include(*non_farming_exemptions)
          end
        end
      end

      context "when user is not farm affiliated" do
        before { allow(transient_registration).to receive(:farm_affiliated?).and_return(false) }

        [true, false, nil].each do |confirm_value|
          context "when temp_add_additional_non_bucket_exemptions is #{confirm_value.inspect}" do
            let(:temp_add_additional_non_bucket_exemptions) { confirm_value }

            it "returns all exemptions", :aggregate_failures do
              exemptions = helper.selected_activity_exemptions(transient_registration)
              expect(exemptions).to include(*farming_exemptions)
              expect(exemptions).to include(*non_farming_exemptions)
            end
          end
        end
      end

      context "when there is no farmer bucket" do
        before do
          allow(WasteExemptionsEngine::Bucket).to receive(:farmer_bucket).and_return(nil)
        end

        it "returns all exemptions regardless of temp_add_additional_non_bucket_exemptions value", :aggregate_failures do
          [true, false, nil].each do |confirm_value|
            transient_registration.temp_add_additional_non_bucket_exemptions = confirm_value
            exemptions = helper.selected_activity_exemptions(transient_registration)
            expect(exemptions).to include(*farming_exemptions)
            expect(exemptions).to include(*non_farming_exemptions)
          end
        end
      end
    end
  end
end
