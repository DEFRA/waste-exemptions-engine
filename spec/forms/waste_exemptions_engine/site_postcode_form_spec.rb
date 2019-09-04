# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SitePostcodeForm, type: :model do
    subject(:form) { build(:site_postcode_form) }

    it_behaves_like "a validated form", :site_postcode_form do
      let(:valid_params) { { token: form.token, temp_site_postcode: "BS1 5AH" } }
      let(:invalid_params) do
        [
          { token: form.token, temp_site_postcode: Helpers::TextGenerator.random_string(256) },
          { token: form.token, temp_site_postcode: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the site postcode" do
          postcode = "BS1 5AH"
          valid_params = { token: form.token, temp_site_postcode: postcode }
          transient_registration = form.transient_registration

          expect(transient_registration.temp_site_postcode).to be_blank
          form.submit(valid_params)
          expect(transient_registration.temp_site_postcode).to eq(postcode)
        end
      end
    end
  end
end
