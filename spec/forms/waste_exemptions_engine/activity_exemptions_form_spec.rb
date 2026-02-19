# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ActivityExemptionsForm, type: :model do
    subject(:form) { build(:activity_exemptions_form) }

    let(:transient_registration) { form.transient_registration }
    let(:farmer_bucket) { create(:bucket, bucket_type: "farmer", exemptions: build_list(:exemption, 3)) }
    let(:three_exemptions) { Exemption.where.not(id: farmer_bucket.exemption_ids).order("RANDOM()").last(3) }

    before do
      farmer_bucket
      create_list(:exemption, 5)
      transient_registration.order = build(:order)
    end

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
      let(:two_farm_exemptions) { farmer_bucket.exemptions.order("RANDOM()").first(2) }
      let(:farm_exemption_ids) { two_farm_exemptions.map(&:id).map(&:to_s) }
      let(:activity_exemption_ids) { three_exemptions.map(&:id).map(&:to_s) }
      let(:valid_params) { { temp_exemptions: activity_exemption_ids } }

      context "when the order does not include the farmer bucket" do
        before { transient_registration.order.update(bucket: nil) }

        context "when all selected exemptions are non-farm exemptions" do
          let(:valid_params) { { temp_exemptions: activity_exemption_ids } }

          it "sets temp_exemptions to the new exemptions" do
            form.submit(valid_params)

            expect(transient_registration.reload.temp_exemptions).to match_array(activity_exemption_ids)
          end
        end

        context "when the selected exemptions include exemptions which are in the farm bucket" do
          let(:valid_params) { { temp_exemptions: activity_exemption_ids + farm_exemption_ids } }

          it "includes the farm exemptions in temp_exemptions" do
            form.submit(valid_params)

            expect(transient_registration.reload.temp_exemptions)
              .to match_array((activity_exemption_ids + farm_exemption_ids).sort)
          end
        end

        context "when a previously selected non-farm exemption is deselected" do
          let(:valid_params) { { temp_exemptions: activity_exemption_ids } }
          let(:to_be_deselected_exemption_id) { create(:exemption).id.to_s }
          let(:original_exemption_ids) { activity_exemption_ids + [to_be_deselected_exemption_id] }

          before { transient_registration.update(temp_exemptions: original_exemption_ids) }

          it "removes the deselected exemption from the transient registration" do
            form.submit(valid_params)

            expect(transient_registration.reload.temp_exemptions).not_to include(to_be_deselected_exemption_id)
          end
        end

        context "when a previously selected farm exemption is deselected" do
          let(:valid_params) { { temp_exemptions: activity_exemption_ids } }
          let(:to_be_deselected_exemption_id) { farm_exemption_ids.last }
          let(:original_exemption_ids) { activity_exemption_ids + [to_be_deselected_exemption_id] }

          before { transient_registration.update(temp_exemptions: original_exemption_ids) }

          it "removes the deselected exemption from the transient registration" do
            form.submit(valid_params)

            expect(transient_registration.reload.temp_exemptions).not_to include(to_be_deselected_exemption_id)
          end
        end
      end

      context "when the order includes the farmer bucket" do
        before do
          transient_registration.order.update(bucket: farmer_bucket)
          transient_registration.update(temp_exemptions: farm_exemption_ids)
        end

        context "when non-farm exemptions are selected" do
          let(:valid_params) { { temp_exemptions: activity_exemption_ids } }

          it "includes the farm exemptions in temp_exemptions" do
            form.submit(valid_params)

            expect(transient_registration.reload.temp_exemptions)
              .to match_array((activity_exemption_ids + farm_exemption_ids).sort)
          end
        end
      end
    end
  end
end
