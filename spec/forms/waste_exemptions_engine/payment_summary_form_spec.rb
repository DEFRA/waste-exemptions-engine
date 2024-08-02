# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe PaymentSummaryForm, type: :model do
    let(:payment_type) { nil }
    let(:receipt_email) { nil }
    let(:transient_registration) { build(:new_charged_registration, workflow_state: :payment_summary_form, payment_type: payment_type, receipt_email: receipt_email) }

    subject(:form) { build(:payment_summary_form, transient_registration: transient_registration) }

    it "validates the payment type using the PaymentTypeValidator class" do
      validators = form._validators
      expect(validators[:payment_type].first.class).to eq(WasteExemptionsEngine::PaymentTypeValidator)
    end

    it_behaves_like "a validated form", :payment_summary_form do
      let(:valid_params) { { payment_type: "bank_transfer" } }
      let(:invalid_params) do
        [
          { payment_type: "invalid" },
          { payment_type: "" }
        ]
      end
    end

    describe "receipt_email validation" do
      context "when payment_type is card" do
        let(:payment_type) { "card" }

        context "when receipt_email is not present" do
          let(:receipt_email) { nil }

          it "is invalid" do
            expect(form).not_to be_valid
          end

          it "adds an error to the receipt_email attribute after validity checked" do
            form.valid?
            expect(form.errors[:receipt_email]).to be_present
          end
        end

        context "when receipt_email is present" do
          let(:receipt_email) { "test@example.com" }

          it "is valid" do
            expect(form).to be_valid
          end
        end
      end

      context "when payment_type is bank_transfer" do
        let(:payment_type) { "bank_transfer" }

        it "does not validate the receipt_email" do
          expect(form).to be_valid
        end
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the selected payment type" do
          valid_params = { payment_type: "card" }

          expect { form.submit(valid_params) }
            .to change(transient_registration, :payment_type)
            .from(nil).to("card")
        end

        it "updates the transient registration with the receipt email when payment type is card" do
          valid_params = { payment_type: "card", receipt_email: "test@example.com" }
          expect(form.submit(valid_params)).to be(true)
        end
      end

      context "when the form is invalid" do
        it "does not submit" do
          invalid_params = { payment_type: "invalid" }
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
