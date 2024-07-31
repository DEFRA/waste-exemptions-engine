# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe PaymentSummaryForm, type: :model do
    subject(:form) { build(:payment_summary_form) }

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the payment_type option" do
          aggregate_failures do
            expect(form.transient_registration.payment_type).to be_blank
            form.submit({ payment_type: "card" })
            expect(form.transient_registration.payment_type).to eq("card")
          end
        end
      end
    end

    describe "#exemption_costs_presenter" do
      it "returns an ExemptionCostsPresenter" do
        expect(form.exemption_costs_presenter).to be_a(ExemptionCostsPresenter)
      end
    end
  end
end
