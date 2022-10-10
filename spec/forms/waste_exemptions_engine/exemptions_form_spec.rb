# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ExemptionsForm, type: :model do
    before do
      # Create a selection of exemptions. The ExemptionForm needs this as it
      # will validate the selected exemptions (our params) against the
      # collection of exemptions it pulls from the database.
      create_list(:exemption, 5)
    end

    subject(:form) { build(:exemptions_form) }
    let(:three_exemptions) { Exemption.order("RANDOM()").last(3) }

    it "validates the matched exemptions using the ExemptionsValidator class" do
      validators = form._validators
      expect(validators.keys).to include(:exemptions)
      expect(validators[:exemptions].first.class)
        .to eq(WasteExemptionsEngine::ExemptionsValidator)
    end

    it_behaves_like "a validated form", :exemptions_form do
      let(:valid_params) { { exemption_ids: three_exemptions.map(&:id).map(&:to_s) } }
      let(:invalid_params) { { exemption_ids: [] } }
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the selected exemptions" do
          exemption_codes = three_exemptions.map(&:code)
          exemption_id_strings = three_exemptions.map(&:id).map(&:to_s)
          valid_params = { exemption_ids: exemption_id_strings }
          transient_registration = form.transient_registration

          expect(transient_registration.exemptions).to be_empty
          form.submit(valid_params)
          expect(transient_registration.exemptions.map(&:code)).to match_array(exemption_codes)
        end
      end
    end
  end
end
