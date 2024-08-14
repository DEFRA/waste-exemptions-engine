# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationReceivedPendingPaymentForm, type: :model do
    subject(:form) { build(:registration_received_pending_payment_form) }
    describe ".can_navigate_flexibly?" do
      it "returns false" do
        expect(described_class).not_to be_can_navigate_flexibly
      end
    end

    describe "#exemption_costs_presenter" do
      let(:mock_order) { instance_double(Order, bucket: nil) }
      let(:mock_transient_registration) { instance_double(NewChargedRegistration, order: mock_order) }

      before do
        allow(form).to receive(:transient_registration).and_return(mock_transient_registration)
      end

      it "returns an ExemptionCostsPresenter" do
        expect(form.exemption_costs_presenter).to be_a(ExemptionCostsPresenter)
      end

      it "memoizes the presenter" do
        presenter = form.exemption_costs_presenter
        expect(form.exemption_costs_presenter).to eq(presenter)
      end
    end
  end
end
