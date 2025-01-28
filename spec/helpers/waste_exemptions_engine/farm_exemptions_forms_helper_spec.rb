# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FarmExemptionsFormsHelper do

    %i[U T D S].each do |activity|
      let!("activity_#{activity}") { create(:waste_activity) }
      # Use 9..11 to ensure a mix of single- and double-digit codes to test sorting
      (9..11).each do |i|
        let!("exemption_#{activity}#{i}") do
          create(:exemption, waste_activity: send("activity_#{activity}"), code: "#{activity}#{i}")
        end
      end
    end

    # rubocop:disable RSpec/LetSetup
    let!(:farmer_bucket) do
      create(:bucket, bucket_type: "farmer",
                      exemptions: [
                        exemption_S11,
                        exemption_S9,
                        exemption_D10,
                        exemption_D9,
                        exemption_U11
                      ])
    end
    # rubocop:enable RSpec/LetSetup

    describe "#sorted_farm_exemptions" do

      it "returns a list of farm exemptions ordered by activity id and exemption id" do
        expect(helper.sorted_farm_exemptions.pluck(:code)).to eq [
          exemption_U11.code,
          exemption_D9.code,
          exemption_D10.code,
          exemption_S9.code,
          exemption_S11.code
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
        let(:temp_exemptions) do
          [
            exemption_D10.id,
            exemption_S11.id,
            exemption_U11.id
          ]
        end
        let(:transient_registration) { build(:new_charged_registration, temp_exemptions:) }

        it "returns the selected farm exemptions only, sorted U/T/D/S" do
          expect(exemption_list).to eq(
            [
              exemption_U11,
              exemption_D10,
              exemption_S11
            ]
          )
        end
      end
    end
  end
end
