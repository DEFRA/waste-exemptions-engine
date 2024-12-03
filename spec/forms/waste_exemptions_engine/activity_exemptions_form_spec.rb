# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ActivityExemptionsForm, type: :model do
    before do
      create_list(:exemption, 5)
    end

    subject(:form) { build(:activity_exemptions_form) }
    let(:three_exemptions) { Exemption.order("RANDOM()").last(3) }

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
      context "when the form is valid" do
        it "updates the transient registration with the selected activity exemptions" do
          activity_exemptions_id_strings = three_exemptions.map(&:id).map(&:to_s)
          valid_params = { temp_exemptions: activity_exemptions_id_strings }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.temp_exemptions).to be_empty
            form.submit(valid_params)
            expect(transient_registration.temp_exemptions).to match_array(activity_exemptions_id_strings)
          end
        end
      end
    end
  end
end
