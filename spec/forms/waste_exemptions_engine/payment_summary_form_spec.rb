# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe PaymentSummaryForm, type: :model do
    let(:temp_payment_method) { nil }
    let(:transient_registration) { build(:new_charged_registration, workflow_state: :payment_summary_form, temp_payment_method:) }

    subject(:form) { build(:payment_summary_form, transient_registration: transient_registration) }

    it "validates the payment type using the PaymentMethodValidator class" do
      validators = form._validators
      expect(validators[:temp_payment_method].first.class).to eq(WasteExemptionsEngine::PaymentMethodValidator)
    end

    it_behaves_like "a validated form", :payment_summary_form do
      let(:valid_params) { { temp_payment_method: "bank_transfer" } }
      let(:invalid_params) do
        [
          { temp_payment_method: "invalid" },
          { temp_payment_method: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the selected payment type" do
          valid_params = { temp_payment_method: "card" }

          expect { form.submit(valid_params) }
            .to change(transient_registration, :temp_payment_method)
            .from(nil).to("card")
        end
      end

      context "when the form is invalid" do
        it "does not submit" do
          invalid_params = { temp_payment_method: "invalid" }
          expect(form.submit(invalid_params)).to be(false)
        end
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
