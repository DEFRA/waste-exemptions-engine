# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ContactPostcodeForm, type: :model do
    subject(:form) { build(:contact_postcode_form) }

    it_behaves_like "a validated form", :contact_postcode_form do
      let(:valid_params) { { token: form.token, temp_contact_postcode: "BS1 5AH" } }
      let(:invalid_params) do
        [
          { temp_contact_postcode: Helpers::TextGenerator.random_string(256) },
          { temp_contact_postcode: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the contact postcode" do
          postcode = "BS1 5AH"
          valid_params = { temp_contact_postcode: postcode }
          transient_registration = form.transient_registration

          expect(transient_registration.temp_contact_postcode).to be_blank
          form.submit(valid_params)
          expect(transient_registration.temp_contact_postcode).to eq(postcode)
        end
      end
    end
  end
end
