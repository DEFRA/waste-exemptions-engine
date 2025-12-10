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

      context "when multisite and temp_site_id is nil" do
        let(:transient_registration) do
          create(:new_charged_registration,
                 workflow_state: "site_grid_reference_form",
                 is_multisite_registration: true,
                 temp_site_id: nil).tap do |reg|
                   create(:transient_address, :site_address, transient_registration: reg, grid_reference: "ST 12345 67890")
                 end
        end

        it "does not pre-populate the form" do
          form = described_class.new(transient_registration)

          aggregate_failures do
            expect(form.grid_reference).to be_nil
            expect(form.description).to be_nil
          end
        end
      end

      context "when multisite and temp_site_id is set" do
        let(:transient_registration) do
          create(:new_charged_registration, workflow_state: "site_grid_reference_form", is_multisite_registration: true)
        end

        let!(:site) do
          create(:transient_address, :site_address, transient_registration: transient_registration,
                                                    grid_reference: "ST 12345 67890", description: "Test site")
        end

        before { transient_registration.update(temp_site_id: site.id) }

        it "pre-populates from the specified site" do
          form = described_class.new(transient_registration)

          aggregate_failures do
            expect(form.grid_reference).to eq("ST 12345 67890")
            expect(form.description).to eq("Test site")
          end
        end
      end

      context "when single-site with no temp_site_id" do
        let(:transient_registration) do
          create(:new_charged_registration, workflow_state: "site_grid_reference_form").tap do |reg|
            reg.update(is_multisite_registration: false, temp_site_id: nil)
            create(:transient_address, :site_address, transient_registration: reg,
                                                      grid_reference: "ST 11111 22222", description: "First site")
          end
        end

        it "pre-populates from site_address" do
          form = described_class.new(transient_registration)

          aggregate_failures do
            expect(form.grid_reference).to eq("ST 11111 22222")
            expect(form.description).to eq("First site")
          end
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

      context "when creating a new multisite site" do
        let(:transient_registration) do
          create(:new_charged_registration,
                 workflow_state: "site_grid_reference_form",
                 is_multisite_registration: true,
                 temp_site_id: nil)
        end
        let(:form) { described_class.new(transient_registration) }
        let(:params) { { grid_reference: "ST 12345 67890", description: "New site" } }

        it "clears temp_site_id after creation" do
          form.submit(params)

          expect(transient_registration.reload.temp_site_id).to be_nil
        end

        it "creates the site address" do
          expect { form.submit(params) }.to change(transient_registration.transient_addresses, :count).by(1)
        end
      end

      context "when updating an existing site" do
        let(:transient_registration) do
          create(:new_charged_registration,
                 workflow_state: "site_grid_reference_form",
                 is_multisite_registration: true)
        end
        let!(:existing_site) do
          create(:transient_address, :site_address, transient_registration: transient_registration,
                                                    grid_reference: "ST 11111 22222", description: "Original")
        end
        let(:form) do
          transient_registration.update(temp_site_id: existing_site.id)
          described_class.new(transient_registration)
        end
        let(:params) { { grid_reference: "ST 99999 88888", description: "Updated" } }

        it "clears temp_site_id after update" do
          form.submit(params)

          expect(transient_registration.reload.temp_site_id).to be_nil
        end

        it "updates the existing site" do
          form.submit(params)
          existing_site.reload

          aggregate_failures do
            expect(existing_site.grid_reference).to eq("ST 99999 88888")
            expect(existing_site.description).to eq("Updated")
          end
        end
      end
    end

    shared_examples "updates existing site address without creating duplicates" do
      let(:params) { { grid_reference: "ST 12345 67890", description: "Updated site description" } }

      it "updates the existing site record" do
        expect do
          form.submit(params)
          existing_site.reload
        end.to change(existing_site, :grid_reference).to("ST 12345 67890")
                                                     .and change(existing_site, :description).to("Updated site description")
      end

      it "doesn't create a duplicate" do
        expect do
          form.submit(params)
        end.not_to change(transient_registration.transient_addresses, :count)
      end
    end

    context "when editing registration in the back office" do
      let(:transient_registration) do
        create(:back_office_edit_registration).tap do |registration|
          create(:transient_address, :site_using_grid_reference, transient_registration: registration)
        end
      end

      context "when editing multisite registration address" do
        let(:existing_site) { transient_registration.site_addresses.first }
        let(:form) { described_class.new(transient_registration) }

        before do
          transient_registration.registration.update!(is_multisite_registration: true)
          allow(WasteExemptionsEngine::AssignSiteDetailsService).to receive(:run)
          transient_registration.update(temp_site_id: existing_site.id)
        end

        it_behaves_like "updates existing site address without creating duplicates"
      end

      context "when editing single-site registration address with no foreign-keys to registration_exemptions (legacy format)" do
        let(:existing_site) { transient_registration.site_addresses.first }
        let(:form) { described_class.new(transient_registration) }

        before do
          allow(WasteExemptionsEngine::AssignSiteDetailsService).to receive(:run)
          transient_registration.update(temp_site_id: existing_site.id)
        end

        it_behaves_like "updates existing site address without creating duplicates"
      end

      context "when editing single-site registration address with foreign-keys to registration_exemptions" do
        let(:existing_site) { transient_registration.site_addresses.first }
        let(:form) { described_class.new(transient_registration) }

        before do
          transient_registration.transient_registration_exemptions.each { |exemption| exemption.update(transient_address_id: existing_site.id) }
          allow(WasteExemptionsEngine::AssignSiteDetailsService).to receive(:run)
          transient_registration.update(temp_site_id: existing_site.id)
        end

        it_behaves_like "updates existing site address without creating duplicates"
      end
    end
  end
end
