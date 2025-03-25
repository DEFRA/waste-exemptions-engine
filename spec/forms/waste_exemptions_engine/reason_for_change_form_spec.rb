# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ReasonForChangeForm, type: :model do
    subject(:form) { build(:reason_for_change_form) }

    it_behaves_like "a validated form", :reason_for_change_form do
      let(:valid_params) { { reason_for_change: "Valid Reason" } }
      let(:invalid_params) do
        [
          { reason_for_change: nil },
          { reason_for_change: "" },
          { reason_for_change: "a" * 501 }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the reason_for_change text" do
          reason_for_change = "Valid Reason"
          valid_params = { reason_for_change: reason_for_change }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.reason_for_change).to be_blank
            form.submit(valid_params)
            expect(transient_registration.reason_for_change).to eq(reason_for_change)
          end
        end
      end
    end

    describe ".can_navigate_flexibly?" do
      it "returns false" do
        expect(described_class).not_to be_can_navigate_flexibly
      end
    end
  end
end
