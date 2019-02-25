# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SiteGridReferenceForm, type: :model do
    subject(:form) { build(:site_grid_reference_form) }

    describe "validationsvalidation" do
      subject(:validators) { form._validators }

      it "validates the site grid reference using the GridReferenceValidator class" do
        expect(validators.keys).to include(:grid_reference)
        expect(validators[:grid_reference].first.class)
          .to eq(WasteExemptionsEngine::GridReferenceValidator)
      end

      it "validates the site description using the SiteDescriptionValidator class" do
        expect(validators.keys).to include(:description)
        expect(validators[:description].first.class)
          .to eq(WasteExemptionsEngine::SiteDescriptionValidator)
      end
    end

    it_behaves_like "a validated form", :site_grid_reference_form do
      let(:valid_params) do
        {
          token: form.token,
          grid_reference: "ST 58337 72855",
          description: "The waste is stored in an out-building next to the barn."
        }
      end
      let(:invalid_params) do
        [
          { token: form.token, grid_reference: "AA1234567890", description: Helpers::TextGenerator.random_string(501) },
          { token: form.token, grid_reference: "", description: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the site grid reference and description" do
          grid_reference = "ST 58337 72855"
          description = "The waste is stored in an out-building next to the barn."
          valid_params = { token: form.token, grid_reference: grid_reference, description: description }
          transient_registration = form.transient_registration

          expect(transient_registration.temp_grid_reference).to be_blank
          expect(transient_registration.temp_site_description).to be_blank
          form.submit(valid_params)
          expect(transient_registration.temp_grid_reference).to eq(grid_reference)
          expect(transient_registration.temp_site_description).to eq(description)
        end
      end
    end
  end
end
