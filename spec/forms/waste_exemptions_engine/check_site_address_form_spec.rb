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

    describe "submit" do
      let(:form) { build(:check_site_address_form) }

      subject do
        form.submit(temp_reuse_address_for_site_location: temp_reuse_address_for_site_location)
      end

      context "when temp_reuse_address_for_site_location is true for the operators address" do
        let(:temp_reuse_address_for_site_location) { "operator_address_option" }

        it "assigns the operator address as the site address" do
          subject

          expect(form.site_address).to eq(form.operator_address)
        end
      end
    end
  end
end
