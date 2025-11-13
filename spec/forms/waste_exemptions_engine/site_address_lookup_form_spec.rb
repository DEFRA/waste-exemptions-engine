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

    context "when editing an existing multisite address in back office" do
      let(:transient_registration) do
        create(:back_office_edit_registration).tap do |registration|
          create(:transient_address, :site_address, transient_registration: registration)
          registration.update!(is_multisite_registration: true)
        end
      end

      let(:existing_site) { transient_registration.site_addresses.last }
      let(:form) { build(:site_address_lookup_form, transient_registration: transient_registration) }
      let(:valid_params) { { site_address: { uprn: "340116" } } }

      before do
        allow(WasteExemptionsEngine::AssignSiteDetailsService).to receive(:run)
        transient_registration.update(temp_site_id: existing_site.id)
      end

      it "updates the existing site record" do
        expect do
          form.submit(valid_params)
          existing_site.reload
        end.to change(existing_site, :uprn).to("340116")
      end

      it "doesn't create a duplicate" do
        expect do
          form.submit(valid_params)
        end.not_to change(transient_registration.transient_addresses, :count)
      end
    end
  end
end
