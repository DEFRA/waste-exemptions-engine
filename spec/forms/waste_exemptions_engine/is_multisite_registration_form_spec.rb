# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe IsMultisiteRegistrationForm, type: :model do
    before do
      allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
    end

    subject(:form) { build(:is_multisite_registration_form) }

    it "validates the is multisite registration question using the TrueFalseValidator class" do
      validators = form._validators
      aggregate_failures do
        expect(validators[:is_multisite_registration].first.class)
          .to eq(DefraRuby::Validators::TrueFalseValidator)
      end
    end

    it_behaves_like "a validated form", :is_multisite_registration_form do
      let(:valid_params) do
        [
          { is_multisite_registration: "true" },
          { is_multisite_registration: "false" }
        ]
      end
      let(:invalid_params) do
        [
          { is_multisite_registration: "" },
          { is_multisite_registration: nil }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the multisite registration answer" do
          valid_params = { is_multisite_registration: true }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.is_multisite_registration).to be_blank
            form.submit(valid_params)
            expect(transient_registration.reload.is_multisite_registration).to be_truthy
          end
        end

        it "can set multisite registration to false" do
          valid_params = { is_multisite_registration: false }
          transient_registration = form.transient_registration

          aggregate_failures do
            form.submit(valid_params)
            expect(transient_registration.reload.is_multisite_registration).to be_falsey
          end
        end

        context "when selecting single-site and existing site addresses exist" do
          let(:transient_registration) { form.transient_registration }
          let!(:first_site) { create(:transient_address, :site_address, transient_registration: transient_registration) }

          before { create(:transient_address, :site_address, transient_registration: transient_registration) }

          it "sets temp_site_id to the first site address" do
            form.submit(is_multisite_registration: "false")

            expect(transient_registration.reload.temp_site_id).to eq(first_site.id)
          end
        end

        context "when selecting multisite" do
          let(:transient_registration) { form.transient_registration }

          before { create(:transient_address, :site_address, transient_registration: transient_registration) }

          it "does not set temp_site_id" do
            form.submit(is_multisite_registration: "true")

            expect(transient_registration.reload.temp_site_id).to be_nil
          end
        end
      end
    end
  end
end
