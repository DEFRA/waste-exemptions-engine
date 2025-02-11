# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmActivityExemptionsForm, type: :model do
    let(:activity_one) { create(:waste_activity) }
    let(:activity_two) { create(:waste_activity) }
    let(:selected_exemption_ids) { Exemption.order("RANDOM()").last(5).map(&:id) }

    subject(:form) { build(:confirm_activity_exemptions_form) }

    it "validates the matched exemptions using the ExemptionsValidator class" do
      validators = form._validators
      expect(validators[:temp_confirm_exemptions].first.class)
        .to eq(DefraRuby::Validators::TrueFalseValidator)
    end

    it_behaves_like "a validated form", :confirm_activity_exemptions_form do
      let(:valid_params) do
        [
          { temp_confirm_exemptions: "true" },
          { temp_confirm_exemptions: "false" }
        ]
      end
      let(:invalid_params) do
        [
          { temp_confirm_exemptions: "" },
          { temp_confirm_exemptions: nil }
        ]
      end
    end

    describe "#submit" do
      before do
        create_list(:exemption, 5, waste_activity_id: [activity_one.id, activity_two.id].sample)
        form.transient_registration.update(temp_exemptions: selected_exemption_ids)
      end

      context "when temp_confirm_exemptions is true" do
        let(:valid_params) { { temp_confirm_exemptions: "true" } }

        it "copies selected exemptions to transient_registration exemptions" do
          form.submit(valid_params)
          expect(form.transient_registration.exemptions.map(&:id)).to match_array(selected_exemption_ids)
        end
      end

      context "when temp_confirm_exemptions is false" do
        let(:valid_params) { { temp_confirm_exemptions: "false" } }

        it "does not assign the transient_registration exemptions" do
          form.submit(valid_params)
          expect(form.transient_registration.exemptions).to be_empty
        end
      end

      context "when temp_confirm_exemptions is empty" do
        let(:invalid_params) { { temp_confirm_exemptions: "" } }

        it "does not assign the transient_registration exemptions" do
          form.submit(invalid_params)
          expect(form.transient_registration.exemptions).to be_empty
        end
      end
    end
  end
end
