# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ExemptionsSummaryForm, type: :model do
    subject(:form) { build(:exemptions_summary_form) }

    it "delegates exemptions to transient_registration" do
      expect(form.exemptions).to eq(form.transient_registration.exemptions)
    end

    describe "#order" do
      context "when transient_registration has an order" do
        let(:existing_order) { build(:order) }

        before do
          allow(form.transient_registration).to receive(:order).and_return(existing_order)
        end

        it "returns the existing order" do
          expect(form.order).to eq(existing_order)
        end
      end

      context "when transient_registration doesn't have an order" do
        let(:new_order) { build(:order) }

        before do
          allow(form.transient_registration).to receive(:order).and_return(nil)
          allow(WasteExemptionsEngine::OrderCreationService).to receive(:run).and_return(new_order)
        end

        it "creates a new order" do
          expect(form.order).to eq(new_order)
        end

        it "calls OrderCreationService with the correct parameters" do
          form.order
          expect(WasteExemptionsEngine::OrderCreationService).to have_received(:run).with(transient_registration: form.transient_registration)
        end
      end
    end

    describe "#order_calculator" do
      let(:order) { build(:order) }
      let(:calculator) { instance_double(WasteExemptionsEngine::OrderCalculatorService) }

      before do
        allow(form).to receive(:order).and_return(order)
        allow(WasteExemptionsEngine::OrderCalculatorService).to receive(:new).with(order).and_return(calculator)
      end

      it "returns an OrderCalculatorService instance" do
        expect(form.order_calculator).to eq(calculator)
      end

      it "memoizes the calculator" do
        form.order_calculator
        form.order_calculator
        expect(WasteExemptionsEngine::OrderCalculatorService).to have_received(:new).once
      end
    end
  end
end
