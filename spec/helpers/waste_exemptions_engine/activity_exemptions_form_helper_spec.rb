# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ActivityExemptionsFormsHelper do
    describe "#selected_activity_exemptions" do
      let(:activity_one) { create(:waste_activity) }
      let(:activity_two) { create(:waste_activity) }
      let(:activity_three) { create(:waste_activity) }
      let(:transient_registration) { create(:new_charged_registration, temp_waste_activities:) }
      let(:temp_waste_activities) { [activity_one.id, activity_two.id, activity_three.id] }
      let(:farming_exemptions) { create_list(:exemption, 2, waste_activity: activity_one) }
      let(:non_farming_exemptions) { create_list(:exemption, 2, waste_activity: activity_two) }

      before do
        # Actually create the exemptions in the database
        farming_exemptions
        non_farming_exemptions
      end

      it "returns all exemptions for selected activities, including farming exemptions", :aggregate_failures do
        exemptions = helper.selected_activity_exemptions(transient_registration)

        expect(exemptions).to include(*farming_exemptions)
        expect(exemptions).to include(*non_farming_exemptions)
      end
    end

    describe "#exemption_charge_display" do
      let(:initial_charge) { build(:charge, :initial_compliance_charge, charge_amount: 42_000) }
      let(:additional_charge) { build(:charge, :additional_compliance_charge, charge_amount: 7_600) }

      context "when the band has different initial and additional charges" do
        let(:band) { create(:band, initial_compliance_charge: initial_charge, additional_compliance_charge: additional_charge) }
        let(:exemption) { create(:exemption, band: band) }

        it "returns full and discounted charges" do
          expect(helper.exemption_charge_display(exemption)).to eq("£420 (£76)")
        end
      end

      context "when the band has equal initial and additional charges" do
        let(:same_charge) { build(:charge, :additional_compliance_charge, charge_amount: 3_000) }
        let(:band) do
          create(:band,
                 initial_compliance_charge: build(:charge, :initial_compliance_charge, charge_amount: 3_000),
                 additional_compliance_charge: same_charge)
        end
        let(:exemption) { create(:exemption, band: band) }

        it "returns only the full charge" do
          expect(helper.exemption_charge_display(exemption)).to eq("£30")
        end
      end

      context "when the band has no charge" do
        let(:band) do
          create(:band,
                 initial_compliance_charge: build(:charge, :initial_compliance_charge, charge_amount: 0),
                 additional_compliance_charge: build(:charge, :additional_compliance_charge, charge_amount: 0))
        end
        let(:exemption) { create(:exemption, band: band) }

        it "returns £0" do
          expect(helper.exemption_charge_display(exemption)).to eq("£0")
        end
      end
    end

    describe "#farming_capped_charge_amount" do
      context "when a farmer bucket exists" do
        let(:farmer_bucket) do
          create(:bucket, bucket_type: "farmer",
                          initial_compliance_charge: build(:charge, :initial_compliance_charge, charge_amount: 8800))
        end

        before { farmer_bucket }

        it "returns the formatted farmer bucket charge" do
          expect(helper.farming_capped_charge_amount).to eq("£88")
        end
      end
    end

    describe "#farming_exemption?" do
      let(:exemption) { create(:exemption) }

      context "when a farmer bucket exists and the exemption is in it" do
        let(:farmer_bucket) { create(:bucket, bucket_type: "farmer") }

        before { create(:bucket_exemption, bucket: farmer_bucket, exemption: exemption) }

        it "returns true" do
          expect(helper.farming_exemption?(exemption)).to be true
        end
      end

      context "when a farmer bucket exists but the exemption is not in it" do
        before { create(:bucket, bucket_type: "farmer") }

        it "returns false" do
          expect(helper.farming_exemption?(exemption)).to be false
        end
      end

      context "when no farmer bucket exists" do
        it "returns false" do
          expect(helper.farming_exemption?(exemption)).to be false
        end
      end
    end
  end
end
