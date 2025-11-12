# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SiteGridReferenceForm, type: :model do
    subject(:form) { build(:site_grid_reference_form) }

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

    it_behaves_like "a validated form", :site_grid_reference_form do
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

    describe "#initialize" do
      context "when address_finder_error is set on the transient registration" do
        let(:transient_registration) { create(:new_charged_registration, workflow_state: "site_grid_reference_form") }

        before do
          transient_registration.update(address_finder_error: true)
        end

        it "clears the address_finder_error flag" do
          expect do
            described_class.new(transient_registration)
            transient_registration.reload
          end.to change(transient_registration, :address_finder_error)
            .from(true).to(nil)
        end
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the site grid reference and description" do
          grid_reference = "ST 58337 72855"
          description = "The waste is stored in an out-building next to the barn."
          valid_params = { grid_reference: grid_reference, description: description }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.site_address).to be_blank

            form.submit(valid_params)
            transient_registration.reload

            expect(transient_registration.site_address.grid_reference).to eq(grid_reference)
            expect(transient_registration.site_address.description).to eq(description)
          end
        end
      end
    end

    context "when editing an existing multisite address in back office" do
      let(:transient_registration) do
        create(:back_office_edit_registration).tap do |registration|
          create(:transient_address, :site_using_grid_reference, transient_registration: registration)
          registration.update!(is_multisite_registration: true)
        end
      end

      let(:existing_site) { transient_registration.site_addresses.first }
      let(:form) { described_class.new(transient_registration) }

      before do
        allow(WasteExemptionsEngine::AssignSiteDetailsService).to receive(:run)
        transient_registration.update(temp_site_id: existing_site.id)
      end

      it "updates the existing site record" do
        params = { grid_reference: "ST 12345 67890", description: "Updated site description" }

        expect do
          form.submit(params)
          existing_site.reload
        end.to change(existing_site, :grid_reference).to("ST 12345 67890")
                                                     .and change(existing_site, :description).to("Updated site description")
      end

      it "doesn't create a duplicate" do
        params = { grid_reference: "ST 12345 67890", description: "Updated site description" }

        expect do
          form.submit(params)
        end.not_to change(transient_registration.transient_addresses, :count)
      end
    end
  end
end
