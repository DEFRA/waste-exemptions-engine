# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ExemptionParamsService do
    let(:registration) { build(:new_charged_registration) }
    let(:new_exemptions) { ["1", "2", "3"] }
    let(:existing_activity_exemptions) { ["4", "5"] }
    let(:existing_farm_exemptions) { ["6", "7"] }

    before do
      registration.temp_activity_exemptions = existing_activity_exemptions
      registration.temp_farm_exemptions = existing_farm_exemptions
    end

    describe ".run" do
      context "when updating farm exemptions" do
        let(:options) do
          {
            registration: registration,
            exemption_type: :farm,
            new_exemptions: new_exemptions
          }
        end

        context "when temp_add_additional_non_farm_exemptions is true and farm_affiliated is true" do
          before do
            registration.temp_add_additional_non_farm_exemptions = true
            allow(registration).to receive(:farm_affiliated?).and_return(true)
          end

          it "combines farm and activity exemptions" do
            result = described_class.run(options)

            expect(result).to eq(
              temp_farm_exemptions: new_exemptions,
              temp_exemptions: (new_exemptions + existing_activity_exemptions).uniq
            )
          end
        end

        context "when temp_add_additional_non_farm_exemptions is false" do
          before do
            registration.temp_add_additional_non_farm_exemptions = false
            allow(registration).to receive(:farm_affiliated?).and_return(true)
          end

          it "only uses new exemptions" do
            result = described_class.run(options)

            expect(result).to eq(
              temp_farm_exemptions: new_exemptions,
              temp_exemptions: new_exemptions
            )
          end
        end
      end

      context "when updating activity exemptions" do
        let(:options) do
          {
            registration: registration,
            exemption_type: :activity,
            new_exemptions: new_exemptions
          }
        end

        context "when temp_add_additional_non_farm_exemptions is true and farm_affiliated is true" do
          before do
            registration.temp_add_additional_non_farm_exemptions = true
            allow(registration).to receive(:farm_affiliated?).and_return(true)
          end

          it "combines activity and farm exemptions" do
            result = described_class.run(options)

            expect(result).to eq(
              temp_activity_exemptions: new_exemptions,
              temp_exemptions: (new_exemptions + existing_farm_exemptions).uniq
            )
          end
        end

        context "when temp_add_additional_non_farm_exemptions is false" do
          before do
            registration.temp_add_additional_non_farm_exemptions = false
            allow(registration).to receive(:farm_affiliated?).and_return(true)
          end

          it "only uses new exemptions" do
            result = described_class.run(options)

            expect(result).to eq(
              temp_activity_exemptions: new_exemptions,
              temp_exemptions: new_exemptions
            )
          end
        end
      end
    end
  end
end
