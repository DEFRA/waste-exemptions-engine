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

    it "validates the T28 exemption using the T28ExemptionValidator class" do
      validators = form._validators
      expect(validators[:temp_exemptions].map(&:class))
        .to include(WasteExemptionsEngine::T28ExemptionValidator)
    end

    describe "#front_office?" do
      context "when in the front office" do
        before do
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
        end

        it "returns true" do
          expect(form.send(:front_office?)).to be(true)
        end
      end

      context "when in the back office" do
        before do
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true)
        end

        it "returns false" do
          expect(form.send(:front_office?)).to be(false)
        end
      end
    end

    describe "T28 exemption validation" do
      let(:t28_exemption) { create(:exemption, code: "T28") }

      context "when in the front office" do
        before do
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
          transient_registration.temp_exemptions = [t28_exemption.id.to_s]
        end

        it "is not valid when T28 exemption is selected" do
          expect(form).not_to be_valid
        end

        it "includes the T28 error message" do
          form.valid?
          expect(form.errors[:temp_exemptions]).to include(
            I18n.t("activemodel.errors.models.waste_exemptions_engine/activity_exemptions_form.attributes.temp_exemptions.t28_exemption_selected")
          )
        end
      end

      context "when in the back office" do
        before do
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true)
          transient_registration.temp_exemptions = [t28_exemption.id.to_s]
        end

        it "is valid when T28 exemption is selected" do
          expect(form).to be_valid
        end

        it "does not add T28 validation errors" do
          form.valid?
          expect(form.errors[:temp_exemptions]).to be_empty
        end
      end
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
