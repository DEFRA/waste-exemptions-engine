# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe MultisiteExemptionsSummaryForm, type: :model do
    subject(:form) { build(:multisite_exemptions_summary_form) }

    it "delegates exemptions to transient_registration" do
      expect(form.exemptions).to eq(form.transient_registration.exemptions)
    end

    describe "#order" do
      context "when transient_registration has an order" do
        let(:existing_order) { create(:order) }

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
          allow(WasteExemptionsEngine::CreateOrUpdateOrderService).to receive(:run).and_return(new_order)
        end

        it "creates a new order" do
          expect(form.order).to eq(new_order)
        end

        it "calls CreateOrUpdateOrderService with the correct parameters" do
          form.order
          expect(WasteExemptionsEngine::CreateOrUpdateOrderService).to have_received(:run).with(transient_registration: form.transient_registration)
        end
      end
    end

    describe "#exemption_costs_presenter" do
      let(:order) { build(:order) }
      let(:presenter) { instance_double(WasteExemptionsEngine::ExemptionCostsPresenter) }

      before do
        allow(form).to receive(:order).and_return(order)
        allow(WasteExemptionsEngine::ExemptionCostsPresenter).to receive(:new).with(order:).and_return(presenter)
      end

      it "returns an ExemptionCostsPresenter instance" do
        expect(form.exemption_costs_presenter).to eq(presenter)
      end

      it "memoizes the presenter" do
        form.exemption_costs_presenter
        form.exemption_costs_presenter
        expect(WasteExemptionsEngine::ExemptionCostsPresenter).to have_received(:new).once
      end
    end
  end
end
