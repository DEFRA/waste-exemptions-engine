# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ActivityExemptionsForm, type: :model do
    before do
      create_list(:exemption, 5)
    end

    subject(:form) { build(:activity_exemptions_form) }
    let(:transient_registration) { form.transient_registration }
    let(:three_exemptions) { Exemption.order("RANDOM()").last(3) }
    let(:two_farm_exemptions) { Exemption.order("RANDOM()").first(2) }

    it "validates the matched exemptions using the ExemptionsValidator class" do
      validators = form._validators
      expect(validators[:temp_exemptions].first.class)
        .to eq(WasteExemptionsEngine::ExemptionsValidator)
    end

    it_behaves_like "a validated form", :activity_exemptions_form do
      let(:valid_params) { { temp_exemptions: three_exemptions.map(&:id).map(&:to_s) } }
      let(:invalid_params) { { temp_exemptions: [] } }
    end

    describe "#submit" do
      let(:farmer_bucket) { create(:bucket, bucket_type: "farmer") }
      let(:farm_exemptions) { two_farm_exemptions.map(&:id).map(&:to_s) }
      let(:activity_exemptions) { three_exemptions.map(&:id).map(&:to_s) }
      let(:valid_params) { { temp_exemptions: activity_exemptions } }

      context "when there are no farm exemptions" do
        it "sets temp_exemptions to the new exemptions" do
          form.submit(valid_params)

          expect(transient_registration.reload.temp_exemptions).to match_array(activity_exemptions)
        end
      end

      context "when there are farm exemptions already present" do
        before do
          # Associate farm exemptions with farmer bucket
          two_farm_exemptions.each { |exemption| create(:bucket_exemption, bucket: farmer_bucket, exemption: exemption) }
          form.transient_registration.temp_exemptions = farm_exemptions
        end

        it "combines the new exemptions with the farm exemptions" do
          form.submit(valid_params)

          expect(transient_registration.reload.temp_exemptions).to match_array((farm_exemptions + activity_exemptions).uniq)
        end
      end

      context "when there are non-farm exemptions already present" do
        before do
          farmer_bucket
          create(:exemption, id: 999)
          form.transient_registration.temp_exemptions = ["999"]
        end

        it "onlies keep the new non-farm exemptions" do
          form.submit(valid_params)

          expect(transient_registration.reload.temp_exemptions).to match_array(activity_exemptions)
        end
      end
    end
  end
end
