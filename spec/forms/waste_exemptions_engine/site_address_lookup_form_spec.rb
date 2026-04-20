# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SiteAddressLookupForm, type: :model do
    before { VCR.insert_cassette("postcode_valid") }
    after { VCR.eject_cassette }

    it_behaves_like "an address lookup form"

    it "validates the site address using the AddressValidator class" do
      validators = build(:site_address_lookup_form)._validators
      aggregate_failures do
        expect(validators[:site_address].first.class)
          .to eq(WasteExemptionsEngine::AddressValidator)
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the selected address" do
          form = build(:site_address_lookup_form)
          address_uprn = %w[340116 340117].sample
          valid_params = { site_address: { uprn: address_uprn } }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.transient_addresses).to be_empty
            form.submit(valid_params)
            transient_registration.reload
            expect(transient_registration.transient_addresses.count).to eq(1)
            expect(transient_registration.transient_addresses.first.uprn).to eq(address_uprn)
          end
        end
      end

      context "when the England-only restriction is enabled" do
        let(:transient_registration) do
          create(:new_charged_registration, workflow_state: "site_address_lookup_form", temp_site_postcode: "BS1 5AH")
        end
        let(:form) { described_class.new(transient_registration) }

        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).and_call_original
          allow(WasteExemptionsEngine::FeatureToggle)
            .to receive(:active?).with(:restrict_site_locations_to_england).and_return(true)
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
        end

        it "filters out addresses confirmed to be outside England" do
          allow(WasteExemptionsEngine::CheckSiteLocationIsInEnglandService).to receive(:run)
            .with(grid_reference: nil, easting: "358205.03", northing: "172708.07")
            .and_return(true)
          allow(WasteExemptionsEngine::CheckSiteLocationIsInEnglandService).to receive(:run)
            .with(grid_reference: nil, easting: "358130.1", northing: "172687.87")
            .and_return(false)

          filtered_form = described_class.new(transient_registration)

          expect(filtered_form.temp_addresses.pluck("uprn")).to contain_exactly(340_116)
        end

        context "when the submitted address is outside England" do
          before do
            allow(WasteExemptionsEngine::CheckSiteLocationIsInEnglandService).to receive(:run).and_return(false)
          end

          it "returns false for a submitted address outside England" do
            expect(form.submit(site_address: { uprn: "340116" })).to be(false)
          end

          it "adds an England-only validation error for a submitted address outside England" do
            form.submit(site_address: { uprn: "340116" })

            expect(form.errors.added?(:site_address, :not_in_england)).to be(true)
          end
        end
      end
    end

    it_behaves_like "a validated form", :site_address_lookup_form do
      let(:valid_params) { { site_address: { uprn: "340116" } } }
      let(:invalid_params) do
        [
          { site_address: { uprn: "foo" } },
          { site_address: { uprn: "" } }
        ]
      end
    end

    shared_examples "updates existing site address without creating duplicates" do
      let(:params) { { site_address: { uprn: "340116" } } }

      it "updates the existing site record" do
        expect do
          form.submit(params)
          existing_site.reload
        end.to change(existing_site, :uprn).to("340116")
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

      context "when editing an existing multisite address in back office" do
        let(:existing_site) { transient_registration.site_addresses.last }
        let(:form) { build(:site_address_lookup_form, transient_registration: transient_registration) }

        before do
          transient_registration.registration.update!(is_multisite_registration: true)
          allow(WasteExemptionsEngine::AssignSiteDetailsService).to receive(:run)
          transient_registration.update(temp_site_id: existing_site.id)
        end

        it_behaves_like "updates existing site address without creating duplicates"
      end

      context "when editing single-site registration address with no foreign-keys to registration_exemptions (legacy format)" do
        let(:existing_site) { transient_registration.site_addresses.last }
        let(:form) { build(:site_address_lookup_form, transient_registration: transient_registration) }

        before do
          allow(WasteExemptionsEngine::AssignSiteDetailsService).to receive(:run)
          transient_registration.update(temp_site_id: existing_site.id)
        end

        it_behaves_like "updates existing site address without creating duplicates"
      end

      context "when editing single-site registration address with foreign-keys to registration_exemptions" do
        let(:existing_site) { transient_registration.site_addresses.last }
        let(:form) { build(:site_address_lookup_form, transient_registration: transient_registration) }

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
