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

      before do
        # Associate farm exemptions with farmer bucket
        two_farm_exemptions.each { |exemption| create(:bucket_exemption, bucket: farmer_bucket, exemption: exemption) }
        form.transient_registration.temp_exemptions = farm_exemptions
      end

      context "when temp_add_additional_non_farm_exemptions is false" do
        before do
          transient_registration.temp_add_additional_non_farm_exemptions = false
        end

        it "returns" do
          form.submit(valid_params)

          expect(form.transient_registration.temp_exemptions).to match_array(activity_exemptions)
        end
      end

      context "when temp_add_additional_non_farm_exemptions is true" do
        before do
          transient_registration.temp_add_additional_non_farm_exemptions = true
          allow(transient_registration).to receive(:farm_affiliated?).and_return(true)
        end

        it "combines with farm exemptions" do
          form.submit(valid_params)

          expect(form.transient_registration.temp_exemptions).to match_array((farm_exemptions + activity_exemptions).uniq)
        end
      end
    end
  end
end
