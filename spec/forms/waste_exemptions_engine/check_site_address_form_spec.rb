# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CheckSiteAddressForm, type: :model do
    let(:form_data) do
      {
        premises: "Example Operator House",
        street_address: "2 On The Road",
        locality: "Near Horizon House",
        city: "Bristol",
        postcode: "BS1 5AH"
      }
    end

    it_behaves_like "a validated form", :check_site_address_form do
      let(:valid_params) do
        [
          { temp_reuse_address_for_site_location: "operator_address_option" },
          { temp_reuse_address_for_site_location: "contact_address_option" },
          { temp_reuse_address_for_site_location: "a_different_address" }
        ]
      end
      let(:invalid_params) do
        [
          { temp_reuse_address_for_site_location: "" }
        ]
      end
    end

    let(:address_attributes) { (TransientAddress.attribute_names - %w[id created_at updated_at address_type]) }

    describe "submit" do
      let(:form) { build(:check_site_address_form) }

      subject do
        form.submit(temp_reuse_address_for_site_location: temp_reuse_address_for_site_location)
      end

      context "when temp_reuse_address_for_site_location is wet to operator_address_option" do
        let(:temp_reuse_address_for_site_location) { "operator_address_option" }

        it "uses the operator address as the site address" do
          subject

          address_attributes.each do |attr|
            expect(form.transient_registration.site_address.send(attr)).to eq(form.operator_address.send(attr))
          end
        end
      end

      context "when temp_reuse_address_for_site_location set to contact_address_option" do
        let(:temp_reuse_address_for_site_location) { "contact_address_option" }

        it "uses the contact address as the site address" do
          subject

          address_attributes.each do |attr|
            expect(form.transient_registration.site_address.send(attr)).to eq(form.operator_address.send(attr))
          end
        end
      end

      context "when temp_reuse_address_for_site_location is set to a_different_address" do
        let(:temp_reuse_address_for_site_location) { "a_different_address" }

        it "uses the contact address as the site address" do
          subject

          expect(form.transient_registration.site_address).to be_blank
        end
      end
    end
  end
end
