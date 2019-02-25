# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ExemptionsForm, type: :model do
    before(:context) do
      # Create a selection of exemptions. The ExemptionForm needs this as it
      # will validate the selected exemptions (our params) against the
      # collection of exemptions it pulls from the database.
      create_list(:exemption, 5)
    end

    subject(:form) { build(:exemptions_form) }

    it "validates the matched exemptions using the ExemptionsValidator class" do
      validators = form._validators
      expect(validators.keys).to include(:matched_exemptions)
      expect(validators[:matched_exemptions].first.class)
        .to eq(WasteExemptionsEngine::ExemptionsValidator)
    end

    it_behaves_like "a validated form", :exemptions_form do
      let(:valid_params) { { token: form.token, exemptions: %w[1 2 3] } }
      let(:invalid_params) { { token: form.token } }
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the selected exemptions" do
          exemptions = %w[1 2 3]
          exemption_codes = exemptions.map { |id| "U#{id}" }
          valid_params = { token: form.token, exemptions: exemptions }
          transient_registration = form.transient_registration

          expect(transient_registration.exemptions).to be_empty
          form.submit(valid_params)
          expect(transient_registration.exemptions.map(&:code)).to eq(exemption_codes)
        end
      end
    end
  end
end
