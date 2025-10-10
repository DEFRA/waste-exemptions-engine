# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SitePostcodeForm, type: :model do
    before do
      allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
    end

    subject(:form) { build(:site_postcode_form) }

    it_behaves_like "a validated form", :site_postcode_form do
      let(:valid_params) { { temp_site_postcode: "BS1 5AH" } }
      let(:invalid_params) do
        [
          { temp_site_postcode: Helpers::TextGenerator.random_string(256) },
          { temp_site_postcode: "" }
        ]
      end
    end

    describe "#initialize" do
      context "when the registration is multisite" do
        let(:transient_registration) do
          create(:new_charged_registration,
                 workflow_state: "site_postcode_form",
                 is_multisite_registration: true,
                 temp_site_postcode: "BS1 5AH")
        end

        it "clears the temp_site_postcode" do
          expect do
            described_class.new(transient_registration)
            transient_registration.reload
          end.to change(transient_registration, :temp_site_postcode)
            .from("BS1 5AH").to(nil)
        end
      end

      context "when the registration is not multisite" do
        let(:transient_registration) do
          create(:new_registration,
                 workflow_state: "site_postcode_form",
                 temp_site_postcode: "BS1 5AH")
        end

        it "does not clear the temp_site_postcode" do
          expect do
            described_class.new(transient_registration)
            transient_registration.reload
          end.not_to change(transient_registration, :temp_site_postcode)
        end
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the site postcode" do
          postcode = "BS1 5AH"
          valid_params = { temp_site_postcode: postcode }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.temp_site_postcode).to be_blank
            form.submit(valid_params)
            expect(transient_registration.temp_site_postcode).to eq(postcode)
          end
        end
      end
    end
  end
end
