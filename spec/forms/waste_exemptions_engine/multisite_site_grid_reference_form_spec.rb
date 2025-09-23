# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe MultisiteSiteGridReferenceForm, type: :model do
    before do
      allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
    end

    let(:form) { build(:multisite_site_grid_reference_form) }

    describe "validations" do
      subject(:validators) { form._validators }

      it "validates the site grid reference using the GridReferenceValidator class" do
        aggregate_failures do
          expect(validators[:grid_reference].first.class)
            .to eq(DefraRuby::Validators::GridReferenceValidator)
        end
      end

      it "validates the site description using the SiteDescriptionValidator class" do
        aggregate_failures do
          expect(validators[:description].first.class)
            .to eq(WasteExemptionsEngine::SiteDescriptionValidator)
        end
      end
    end

    it_behaves_like "a validated form", :multisite_site_grid_reference_form do
      let(:valid_params) do
        {
          grid_reference: "ST 58337 72855",
          description: "The waste is stored in an out-building next to the barn."
        }
      end
      let(:invalid_params) do
        [
          { grid_reference: "AA1234567890", description: Helpers::TextGenerator.random_string(501) },
          { grid_reference: "", description: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        let(:valid_params) do
          {
            grid_reference: "ST1234567890",
            description: "Test site description"
          }
        end

        it "returns true" do
          expect(form.submit(valid_params)).to be(true)
        end

        it "creates a new transient address" do
          expect { form.submit(valid_params) }.to change { form.transient_registration.transient_addresses.count }.by(1)
        end

        it "creates the address with correct attributes" do
          form.submit(valid_params)
          address = form.transient_registration.transient_addresses.last
          expect(address).to have_attributes(
            grid_reference: "ST1234567890",
            description: "Test site description",
            address_type: "site",
            mode: "auto"
          )
        end
      end
    end
  end
end
