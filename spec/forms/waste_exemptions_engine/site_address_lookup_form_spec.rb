# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SiteAddressLookupForm, type: :model do
    before { VCR.insert_cassette("postcode_valid") }
    after { VCR.eject_cassette }

    it_behaves_like "an address lookup form"

    it "validates the site address using the AddressValidator class" do
      validators = build(:site_address_lookup_form)._validators
      expect(validators.keys).to include(:site_address)
      expect(validators[:site_address].first.class)
        .to eq(WasteExemptionsEngine::AddressValidator)
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the selected address" do
          form = build(:site_address_lookup_form)
          address_uprn = %w[340116 340117].sample
          valid_params = { site_address: { uprn: address_uprn } }
          transient_registration = form.transient_registration

          expect(transient_registration.transient_addresses).to be_empty
          form.submit(valid_params)
          transient_registration.reload
          expect(transient_registration.transient_addresses.count).to eq(1)
          expect(transient_registration.transient_addresses.first.uprn).to eq(address_uprn)
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
  end
end
