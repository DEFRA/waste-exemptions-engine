# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FarmExemptionsFormsHelper do

    %i[y z w x].each do |activity|
      let!("activity_#{activity}") { create(:waste_activity) }
      (1..3).each do |i|
        let!("exemption_#{activity}_#{i}") do
          create(:exemption, waste_activity: send("activity_#{activity}"), code: "#{activity}#{i}")
        end
      end
    end

    # rubocop:disable RSpec/LetSetup
    let!(:farmer_bucket) do
      create(:bucket, bucket_type: "farmer",
                      exemptions: [
                        exemption_x_2,
                        exemption_x_1,
                        exemption_w_1,
                        exemption_w_3,
                        exemption_y_2
                      ])
    end
    # rubocop:enable RSpec/LetSetup

    describe "#sorted_farm_exemptions" do

      it "returns a list of farm exemptions ordered by activity id and exemption id" do
        expect(helper.sorted_farm_exemptions.pluck(:code)).to eq [
          exemption_y_2.code,
          exemption_w_1.code,
          exemption_w_3.code,
          exemption_x_1.code,
          exemption_x_2.code
        ]
      end
    end

    describe "#selected_farm_exemptions" do

      subject(:exemption_list) { helper.selected_farm_exemptions(transient_registration) }

      context "with no selected exemptions" do
        let(:transient_registration) { build(:new_charged_registration, temp_exemptions: nil) }

        it { expect(exemption_list).to eq [] }
      end

      context "with some selected exemptions" do
        let(:transient_registration) { build(:new_charged_registration, temp_exemptions: Exemption.pluck(:id)) }

        it "returns the selected farm exemptions" do
          expect(exemption_list).to include(
            exemption_y_2,
            exemption_w_1,
            exemption_w_3,
            exemption_x_1,
            exemption_x_2
          )
        end

        it "does not include the non-farm exemption" do
          expect(exemption_list).not_to include(exemption_z_1)
        end
      end
    end
  end
end
