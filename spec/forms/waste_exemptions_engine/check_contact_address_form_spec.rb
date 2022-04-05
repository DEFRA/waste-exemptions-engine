# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CheckContactAddressForm, type: :model do
    it_behaves_like "a validated form", :check_contact_address_form do
      let(:valid_params) do
        [
          { temp_reuse_operator_address: "true" },
          { temp_reuse_operator_address: "false" }
        ]
      end
      let(:invalid_params) do
        [
          { temp_reuse_operator_address: "" }
        ]
      end
    end

    describe "#submit" do
      let(:form) { build(:check_contact_address_form) }

      subject do
        form.submit(temp_reuse_operator_address: temp_reuse_operator_address)
      end

      context "when temp_reuse_operator_address is true" do
        let(:temp_reuse_operator_address) { "true" }

        it "creates contact_address with the correct address_type" do
          subject

          expect(form.contact_address.address_type).to eq "contact"
        end

        it "copies the applicant_address details to the contact_address" do
          subject

          (TransientAddress.attribute_names - %w[id created_at updated_at address_type]).each do |attr|
            expect(form.contact_address.send(attr)).to eq(form.operator_address.send(attr))
          end
        end
      end

      context "when temp_reuse_operator_address is false" do
        let(:temp_reuse_operator_address) { "false" }

        it "does not assign the contact_address" do
          subject

          expect(form.transient_registration.contact_address).to be_blank
        end
      end
    end
  end
end
