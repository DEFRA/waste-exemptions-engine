# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewalStartForm, type: :model do
    subject(:form) { build(:renewal_start_form) }

    it "validates the on a farm question using the YesNoValidator class" do
      validators = form._validators
      aggregate_failures do
        expect(validators[:temp_renew_without_changes].first.class)
          .to eq(DefraRuby::Validators::TrueFalseValidator)
      end
    end

    it_behaves_like "a validated form", :renewal_start_form do
      let(:valid_params) do
        [
          { temp_renew_without_changes: "true" },
          { temp_renew_without_changes: "false" }
        ]
      end
      let(:invalid_params) do
        [
          { temp_renew_without_changes: "" }
        ]
      end
    end

    describe "#initialize" do
      let(:transient_registration) { form.transient_registration }

      let(:valid_params) { {} }

      before do
        transient_registration.registration_exemptions = []
        transient_registration.save!
        transient_registration.reload
      end

      it "resets exemptions based on the referring registration" do
        aggregate_failures do
          expect(transient_registration.exemptions).to be_empty # sanity

          described_class.new(transient_registration)

          transient_registration.reload

          expect(transient_registration.exemptions).not_to be_empty

          expect(transient_registration.exemptions.map(&:id).sort)
            .to eq(transient_registration.referring_registration.exemptions.map(&:id).sort)
        end
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the renewal type answer" do
          temp_renew_without_changes = %w[true false].sample
          valid_params = { temp_renew_without_changes: temp_renew_without_changes }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.temp_renew_without_changes).to be_blank
            form.submit(valid_params)
            expect(transient_registration.temp_renew_without_changes).to eq(temp_renew_without_changes == "true")
          end
        end
      end
    end
  end
end
