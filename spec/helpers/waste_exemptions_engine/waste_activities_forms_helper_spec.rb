# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe WasteActivitiesFormsHelper do
    describe "#all_categories" do
      it "returns a list of all waste activity categories" do
        expect(helper.all_categories).to eq(WasteActivity::ACTIVITY_CATEGORIES.keys)
      end
    end

    describe "#category_activities" do
      let(:category) { WasteActivity::ACTIVITY_CATEGORIES.keys.sample }

      before do
        create_list(:waste_activity, 5)
      end

      it "returns a list of waste activities filtered by category" do
        expect(helper.category_activities(category)).to eq(WasteActivity.where(category: category))
      end
    end

    describe "#exemption_codes_for_activity" do
      let(:activity) { create(:waste_activity) }
      let(:transient_registration) { create(:new_charged_registration, temp_add_additional_non_bucket_exemptions:) }
      let(:temp_add_additional_non_bucket_exemptions) { true }
      let(:farmer_bucket) { create(:bucket) }
      let(:regular_exemptions) { create_list(:exemption, 3, waste_activity: activity) }
      let(:farm_exemption) { create(:exemption, code: "U4", waste_activity: activity) }

      before do
        # Create exemptions in the database
        regular_exemptions
        farm_exemption

        # Set up the farmer bucket with the farm exemption
        allow(WasteExemptionsEngine::Bucket).to receive(:farmer_bucket).and_return(farmer_bucket)
        allow(farmer_bucket).to receive(:exemption_ids).and_return([farm_exemption.id])
      end

      it "returns a comma-separated list of exemption codes" do
        # Without farm exemption filtering
        allow(transient_registration).to receive(:farm_affiliated?).and_return(false)
        result = helper.exemption_codes_for_activity(activity, transient_registration)
        result_codes = result.split(", ").sort
        expected_codes = (regular_exemptions + [farm_exemption]).map(&:code).sort
        expect(result_codes).to eq(expected_codes)
      end

      context "when activity has no exemptions" do
        let(:activity_without_exemptions) { create(:waste_activity) }

        it "returns an empty string" do
          expect(helper.exemption_codes_for_activity(activity_without_exemptions, transient_registration)).to eq("")
        end
      end

      context "when user is farm affiliated" do
        before { allow(transient_registration).to receive(:farm_affiliated?).and_return(true) }

        context "when temp_add_additional_non_bucket_exemptions is true" do
          let(:temp_add_additional_non_bucket_exemptions) { true }

          it "excludes farm exemptions", :aggregate_failures do
            result = helper.exemption_codes_for_activity(activity, transient_registration)
            result_codes = result.split(", ").sort
            expected_codes = regular_exemptions.map(&:code).sort

            expect(result_codes).to eq(expected_codes)
            expect(result).not_to include(farm_exemption.code)
          end
        end

        context "when temp_add_additional_non_bucket_exemptions is false" do
          let(:temp_add_additional_non_bucket_exemptions) { false }

          it "includes farm exemptions", :aggregate_failures do
            result = helper.exemption_codes_for_activity(activity, transient_registration)
            result_codes = result.split(", ").sort
            expected_codes = (regular_exemptions + [farm_exemption]).map(&:code).sort

            expect(result_codes).to eq(expected_codes)
            expect(result).to include(farm_exemption.code)
          end
        end

        context "when temp_add_additional_non_bucket_exemptions is nil" do
          let(:temp_add_additional_non_bucket_exemptions) { nil }

          it "includes farm exemptions", :aggregate_failures do
            result = helper.exemption_codes_for_activity(activity, transient_registration)
            result_codes = result.split(", ").sort
            expected_codes = (regular_exemptions + [farm_exemption]).map(&:code).sort

            expect(result_codes).to eq(expected_codes)
            expect(result).to include(farm_exemption.code)
          end
        end
      end

      context "when user is not farm affiliated" do
        before { allow(transient_registration).to receive(:farm_affiliated?).and_return(false) }

        [true, false, nil].each do |confirm_value|
          context "when temp_add_additional_non_bucket_exemptions is #{confirm_value.inspect}" do
            let(:temp_add_additional_non_bucket_exemptions) { confirm_value }

            it "includes all exemptions", :aggregate_failures do
              result = helper.exemption_codes_for_activity(activity, transient_registration)
              result_codes = result.split(", ").sort
              expected_codes = (regular_exemptions + [farm_exemption]).map(&:code).sort

              expect(result_codes).to eq(expected_codes)
              expect(result).to include(farm_exemption.code)
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
            result = helper.exemption_codes_for_activity(activity, transient_registration)
            result_codes = result.split(", ").sort
            expected_codes = (regular_exemptions + [farm_exemption]).map(&:code).sort

            expect(result_codes).to eq(expected_codes)
            expect(result).to include(farm_exemption.code)
          end
        end
      end
    end
  end
end
