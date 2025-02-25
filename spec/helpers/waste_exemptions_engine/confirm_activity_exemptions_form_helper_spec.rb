# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmActivityExemptionsFormsHelper do
    let(:bands) { create_list(:band, 3) }
    let(:farmer_bucket) { create(:bucket, bucket_type: "farmer") }

    # Create exemptions and associate them with the farmer bucket
    let!(:band_one_farm_exemption) { create(:exemption, id: 2, band: bands[0]) }
    let!(:band_two_farm_exemption) { create(:exemption, id: 1, band: bands[1]) }
    let!(:band_one_standard_exemption) { create(:exemption, id: 4, band: bands[0]) }
    let!(:band_two_standard_exemption) { create(:exemption, id: 3, band: bands[1]) }

    before do
      create(:bucket_exemption, bucket: farmer_bucket, exemption: band_two_farm_exemption)
      create(:bucket_exemption, bucket: farmer_bucket, exemption: band_one_farm_exemption)
    end

    describe "#selected_exemptions" do
      it "returns a list of selected exemptions ordered by band id and exemption id" do
        exemption_ids = [band_two_farm_exemption.id, band_two_standard_exemption.id,
                         band_one_farm_exemption.id, band_one_standard_exemption.id]
        exemptions = helper.selected_exemptions(exemption_ids)

        expect(exemptions.map(&:id)).to eq([band_one_farm_exemption.id, band_one_standard_exemption.id,
                                            band_two_farm_exemption.id, band_two_standard_exemption.id])
      end
    end

    describe "#non_farm_exemptions" do
      let(:transient_registration) do
        create(:new_charged_registration).tap do |reg|
          reg.temp_exemptions = [band_two_farm_exemption.id, band_one_farm_exemption.id,
                                 band_two_standard_exemption.id, band_one_standard_exemption.id]
          reg.save!
        end
      end

      it "returns the correct number of non-farm exemptions" do
        exemptions = helper.non_farm_exemptions(transient_registration)

        expect(exemptions.count).to eq(2)
      end

      it "includes only non-farm exemptions" do
        exemptions = helper.non_farm_exemptions(transient_registration)

        expect(exemptions).to include(band_two_standard_exemption, band_one_standard_exemption)
      end

      it "excludes farm exemptions" do
        exemptions = helper.non_farm_exemptions(transient_registration)

        expect(exemptions).not_to include(band_two_farm_exemption, band_one_farm_exemption)
      end

      it "orders exemptions by band_id and id" do
        exemptions = helper.non_farm_exemptions(transient_registration)

        expect(exemptions.map(&:id)).to eq([band_one_standard_exemption.id, band_two_standard_exemption.id])
      end
    end

    describe "#farm_exemptions" do
      let(:transient_registration) do
        create(:new_charged_registration).tap do |reg|
          reg.temp_exemptions = [band_two_farm_exemption.id, band_one_farm_exemption.id,
                                 band_two_standard_exemption.id]
          reg.save!
        end
      end

      it "returns the correct number of farm exemptions" do
        exemptions = helper.farm_exemptions(transient_registration)

        expect(exemptions.count).to eq(2)
      end

      it "includes only farm exemptions" do
        exemptions = helper.farm_exemptions(transient_registration)

        expect(exemptions).to include(band_two_farm_exemption, band_one_farm_exemption)
      end

      it "excludes non-farm exemptions" do
        exemptions = helper.farm_exemptions(transient_registration)

        expect(exemptions).not_to include(band_two_standard_exemption)
      end

      it "orders exemptions by band_id and id" do
        exemptions = helper.farm_exemptions(transient_registration)

        expect(exemptions.map(&:id)).to eq([band_one_farm_exemption.id, band_two_farm_exemption.id])
      end
    end

    describe "#show_farm_exemptions?" do
      let(:transient_registration) do
        create(:new_charged_registration).tap do |reg|
          reg.temp_add_additional_non_bucket_exemptions = true
          reg.is_a_farmer = farm_affiliated
          reg.on_a_farm = farm_affiliated
          reg.save!
        end
      end

      context "when registration is farm affiliated" do
        let(:farm_affiliated) { true }

        it "returns true when temp_add_additional_non_bucket_exemptions is true" do
          expect(helper.show_farm_exemptions?(transient_registration)).to be true
        end

        it "returns false when temp_add_additional_non_bucket_exemptions is false" do
          transient_registration.update!(temp_add_additional_non_bucket_exemptions: false)
          expect(helper.show_farm_exemptions?(transient_registration)).to be false
        end
      end

      context "when registration is not farm affiliated" do
        let(:farm_affiliated) { false }

        it "returns false" do
          expect(helper.show_farm_exemptions?(transient_registration)).to be false
        end
      end
    end
  end
end
