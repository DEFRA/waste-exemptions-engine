# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ExemptionParamsService do
    let(:registration) { build(:new_charged_registration) }
    let(:farmer_bucket) { create(:bucket, bucket_type: "farmer") }
    let(:new_exemptions) { %w[1 2 3] }
    let(:existing_activity_exemptions) { %w[4 5] }
    let(:existing_farm_exemptions) { %w[6 7] }

    before do
      # Create exemptions and associate farm exemptions with farmer bucket
      existing_farm_exemptions.each do |id|
        exemption = create(:exemption, id: id)
        create(:bucket_exemption, bucket: farmer_bucket, exemption: exemption)
      end
      existing_activity_exemptions.each { |id| create(:exemption, id: id) }

      registration.temp_exemptions = existing_activity_exemptions + existing_farm_exemptions
    end

    describe ".run" do
      context "when given an invalid exemption type" do
        let(:options) do
          {
            registration: registration,
            exemption_type: :invalid,
            new_exemptions: new_exemptions
          }
        end

        it "raises an ArgumentError" do
          expect { described_class.run(options) }.to raise_error(
            ArgumentError,
            "Invalid exemption_type: invalid. Must be :farm or :activity"
          )
        end
      end

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
              temp_exemptions: (new_exemptions + existing_activity_exemptions).uniq.sort
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
              temp_exemptions: new_exemptions.sort
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
              temp_exemptions: (new_exemptions + existing_farm_exemptions).uniq.sort
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
              temp_exemptions: new_exemptions.sort
            )
          end
        end
      end
    end
  end
end
