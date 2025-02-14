# frozen_string_literal: false

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmFarmExemptionsForm, type: :model do
    subject(:form) { build(:confirm_farm_exemptions_form) }

    let(:farmer_bucket) { create(:bucket, bucket_type: "farmer") }
    let(:selected_exemptions) { Exemption.order("RANDOM()").last(5) }
    let(:selected_exemption_ids) { selected_exemptions.map(&:id) }

    it "validates the matched exemptions using the ExemptionsValidator class" do
      validators = form._validators
      expect(validators[:temp_add_additional_non_farm_exemptions].first.class)
        .to eq(DefraRuby::Validators::TrueFalseValidator)
    end

    it_behaves_like "a validated form", :confirm_farm_exemptions_form do
      let(:valid_params) do
        [
          { temp_add_additional_non_farm_exemptions: "false" },
          { temp_add_additional_non_farm_exemptions: "true" }
        ]
      end
      let(:invalid_params) do
        [
          { temp_add_additional_non_farm_exemptions: "" },
          { temp_add_additional_non_farm_exemptions: nil }
        ]
      end
    end

    describe "#submit" do
      before do
        create_list(:exemption, 5)
        selected_exemptions.each { |exemption| create(:bucket_exemption, bucket: farmer_bucket, exemption: exemption) }
        form.transient_registration.update(temp_exemptions: selected_exemption_ids)
      end

      context "when temp_add_additional_non_farm_exemptions is false" do
        let(:valid_params) { { temp_add_additional_non_farm_exemptions: "false" } }

        it "copies selected exemptions to transient_registration exemptions" do
          form.submit(valid_params)
          expect(form.transient_registration.exemptions.map(&:id)).to match_array(selected_exemption_ids)
        end
      end

      context "when temp_add_additional_non_farm_exemptions is true" do
        let(:valid_params) { { temp_add_additional_non_farm_exemptions: "true" } }

        it "does not assign the transient_registration exemptions" do
          form.submit(valid_params)
          expect(form.transient_registration.exemptions).to be_empty
        end
      end

      context "when temp_add_additional_non_farm_exemptions is empty" do
        let(:invalid_params) { { temp_add_additional_non_farm_exemptions: "" } }

        it "does not assign the transient_registration exemptions" do
          form.submit(invalid_params)
          expect(form.transient_registration.exemptions).to be_empty
        end
      end
    end
  end
end
