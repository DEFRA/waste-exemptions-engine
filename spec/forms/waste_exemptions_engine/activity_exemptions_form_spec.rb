# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ActivityExemptionsForm, type: :model do
    before do
      create_list(:exemption, 5)
    end

    subject(:form) { build(:activity_exemptions_form) }
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
      let(:farm_exemptions) { two_farm_exemptions.map(&:id).map(&:to_s) }
      let(:activity_exemptions) { three_exemptions.map(&:id).map(&:to_s) }
      let(:valid_params) { { temp_exemptions: activity_exemptions } }

      before do
        form.transient_registration.temp_farm_exemptions = farm_exemptions
      end

      context "when temp_confirm_exemptions is true" do
        before do
          form.transient_registration.temp_confirm_exemptions = true
          form.transient_registration.temp_activity_exemptions = ["999"]
        end

        it "replaces existing activity exemptions and preserves farm exemptions" do
          form.submit(valid_params)

          aggregate_failures do
            expect(form.transient_registration.temp_activity_exemptions).to match_array(activity_exemptions)
            expect(form.transient_registration.temp_farm_exemptions).to match_array(farm_exemptions)
            expect(form.transient_registration.temp_exemptions).to match_array(farm_exemptions + activity_exemptions)
          end
        end
      end

      context "when temp_confirm_exemptions is false" do
        before do
          form.transient_registration.temp_confirm_exemptions = false
          # Add some existing activity exemptions that should be combined
          form.transient_registration.temp_activity_exemptions = ["999"]
        end

        it "combines with existing activity exemptions and preserves farm exemptions" do
          form.submit(valid_params)

          aggregate_failures do
            expect(form.transient_registration.temp_activity_exemptions).to match_array(["999"] + activity_exemptions)
            expect(form.transient_registration.temp_farm_exemptions).to match_array(farm_exemptions)
            expect(form.transient_registration.temp_exemptions).to match_array(farm_exemptions + ["999"] + activity_exemptions)
          end
        end
      end
    end
  end
end
