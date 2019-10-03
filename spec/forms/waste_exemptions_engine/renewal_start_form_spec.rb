# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewalStartForm, type: :model do
    it_behaves_like "a data overview form", :renewal_start_form

    subject(:form) { build(:renewal_start_form) }

    it "validates the on a farm question using the YesNoValidator class" do
      validators = form._validators
      expect(validators.keys).to include(:temp_renew_without_changes)
      expect(validators[:temp_renew_without_changes].first.class)
        .to eq(DefraRuby::Validators::TrueFalseValidator)
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

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the renewal type answer" do
          temp_renew_without_changes = %w[true false].sample
          valid_params = { temp_renew_without_changes: temp_renew_without_changes }
          transient_registration = form.transient_registration

          expect(transient_registration.temp_renew_without_changes).to be_blank
          form.submit(valid_params)
          expect(transient_registration.temp_renew_without_changes).to eq(temp_renew_without_changes == "true")
        end
      end
    end
  end
end
