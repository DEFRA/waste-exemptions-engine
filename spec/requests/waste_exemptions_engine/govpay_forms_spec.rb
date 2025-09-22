# frozen_string_literal: true

require "webmock/rspec"
require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "GovpayForms" do
    let(:govpay_host) { "https://publicapi.payments.service.gov.uk" }
    let(:order) { build(:order, :with_charge_detail) }
    let(:transient_registration) do
      create(:new_charged_registration,
             order: order,
             workflow_state: "govpay_form",
             workflow_history: ["payment_summary_form"])
    end
    let(:token) { transient_registration[:token] }

    before { allow(Airbrake).to receive(:notify) }

    describe "#new" do
      before do
        stub_request(:any, /.*#{govpay_host}.*/).to_return(
          status: 200,
          body: File.read("./spec/fixtures/files/govpay/get_payment_response_created.json")
        )
      end

      it "creates a registration" do
        expect { get new_govpay_form_path(token) }.to change(Registration, :count).by(1)
      end

      it "sets the transient_registration reference" do
        expect { get new_govpay_form_path(token) }.to change { transient_registration.reload.reference }.from(nil)
      end

      it "doesn't change transient_registration reference if govpay page accessed multiple times" do
        get new_govpay_form_path(token)
        reference = transient_registration.reload.reference
        expect { get new_govpay_form_path(token) }.not_to change { transient_registration.reload.reference }.from(reference)
      end

      it "creates a payment" do
        get new_govpay_form_path(token)
        expect(Registration.last.account.payments.length).to eq(1)
      end

      it "populates govpay_id on the payment" do
        get new_govpay_form_path(token)
        expect(Registration.last.account.payments.last.govpay_id).to be_present
      end

      it "redirects to govpay" do
        get new_govpay_form_path(token)
        expect(response.location).to include("https://www.payments.service.gov.uk")
      end

      context "when there is an error setting up the govpay url" do
        let(:govpay_service) { instance_double(GovpayPaymentService) }

        before do
          allow(GovpayPaymentService).to receive(:new).and_return(govpay_service)
          allow(govpay_service).to receive(:prepare_for_payment).and_return(:error)
        end

        it "redirects to payment_summary_form" do
          get new_govpay_form_path(token)
          expect(response).to redirect_to(new_payment_summary_form_path(token))
        end
      end
    end

    describe "#payment_callback" do
      let(:govpay_host) { "https://publicapi.payments.service.gov.uk" }
      let(:payment_service) { instance_double(GovpayPaymentService) }
      let(:payment_details_service) { instance_double(GovpayPaymentDetailsService) }
      let(:placeholder_registration) { create(:registration, placeholder: true, account: build(:account)) }
      let(:payment) { create(:payment, account: placeholder_registration.account, order: order, payment_status: "created") }

      before do
        allow(Rails.configuration).to receive(:govpay_url).and_return(govpay_host)
        allow(GovpayPaymentService).to receive(:new).and_return(payment_service)
        allow(payment_service).to receive(:prepare_for_payment)
        allow(GovpayPaymentDetailsService).to receive(:new).and_return(payment_details_service)
        allow(payment_details_service).to receive(:govpay_payment_status).and_return(payment_status)

        transient_registration.update(reference: placeholder_registration.reference)
      end

      context "when govpay status is success" do
        let(:payment_status) { "success" }

        context "when the payment_uuid is valid and the balance is paid" do
          it "updates payment status" do
            expect { get payment_callback_govpay_forms_path(token, payment.payment_uuid) }
              .to change { payment.reload.payment_status }.from("created").to("success")
          end

          it "redirects to registration_complete_form" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            expect(response).to redirect_to(new_registration_complete_form_path(token))
          end

          it "does not log an error" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            expect(Airbrake).not_to have_received(:notify)
          end
        end

        context "when the payment uuid is invalid" do
          before do
            stub_request(:any, %r{.*#{govpay_host}/payments}).to_return(
              status: 200,
              body: File.read("./spec/fixtures/files/govpay/get_payment_response_not_found.json")
            )

            get payment_callback_govpay_forms_path(token, "invalid_uuid")
          end

          it "does not update payment status" do
            expect(payment.payment_status).to eq("created")
          end

          it "redirects to payment_summary_form" do
            expect(response).to redirect_to(new_payment_summary_form_path(token))
          end

          it "notifies Airbrake" do
            expect(Airbrake)
              .to have_received(:notify)
              .with("Invalid Govpay response: Cannot find matching order", { payment_uuid: "invalid_uuid" })
          end
        end
      end

      context "when govpay status is submitted" do
        let(:payment_status) { "submitted" }

        context "when the payment_uuid is valid" do
          it "updates payment status" do
            expect { get payment_callback_govpay_forms_path(token, payment.payment_uuid) }
              .to change { payment.reload.payment_status }.from("created").to("submitted")
          end

          it "redirects to registration_complete_form" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            expect(response).to redirect_to(new_registration_complete_form_path(token))
          end

          it "does not log an error" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            expect(Airbrake).not_to have_received(:notify)
          end
        end

        context "when the payment uuid is invalid" do
          before do
            stub_request(:any, %r{.*#{govpay_host}/payments}).to_return(
              status: 200,
              body: File.read("./spec/fixtures/files/govpay/get_payment_response_not_found.json")
            )

            get payment_callback_govpay_forms_path(token, "invalid_uuid")
          end

          it "does not update payment status" do
            expect(payment.payment_status).to eq("created")
          end

          it "redirects to payment_summary_form" do
            expect(response).to redirect_to(new_payment_summary_form_path(token))
          end

          it "notifies Airbrake" do
            expect(Airbrake)
              .to have_received(:notify)
              .with("Invalid Govpay response: Cannot find matching order", { payment_uuid: "invalid_uuid" })
          end
        end
      end

      context "with pending govpay statuses" do
        RSpec.shared_examples "payment is pending" do
          context "when the payment uuid is valid" do
            before do
              payment.update!(payment_status: "created")
            end

            it "redirects to registration_received_pending_payment_form" do
              skip "registration_received_pending_payment_form is not implemented yet"

              get payment_callback_govpay_forms_path(token, payment.payment_uuid)
              expect(response).to redirect_to(new_registration_received_pending_payment_form_path(token))
            end
          end

          context "when the payment uuid is invalid" do
            it "redirects to payment_summary_form" do
              get payment_callback_govpay_forms_path(token, "invalid_payment_uuid")
              expect(response).to redirect_to(new_payment_summary_form_path(token))
            end
          end
        end

        context "when govpay status is created" do
          let(:payment_status) { "created" }

          it_behaves_like "payment is pending"
        end

        context "when govpay status is submitted" do
          let(:payment_status) { "submitted" }

          it_behaves_like "payment is pending"
        end
      end

      context "with unsuccessful govpay statuses" do
        RSpec.shared_examples "payment is unsuccessful but no error" do
          it "redirects to payment_summary_form" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            expect(response).to redirect_to(new_payment_summary_form_path(token))
          end

          it "does not log an error" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            expect(Airbrake).not_to have_received(:notify)
          end
        end

        RSpec.shared_examples "payment is unsuccessful with an error" do
          it "redirects to payment_summary_form" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            expect(response).to redirect_to(new_payment_summary_form_path(token))
          end

          it "logs an error" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            expect(Airbrake).to have_received(:notify).at_least(:once)
          end
        end
      end

      context "with an invalid success status" do
        before { allow(GovpayValidatorService).to receive(:valid_govpay_status?).and_return(false) }

        let(:payment_status) { "success" }

        it_behaves_like "payment is unsuccessful with an error"
      end

      context "with an invalid failure status" do
        before { allow(GovpayValidatorService).to receive(:valid_govpay_status?).and_return(false) }

        let(:payment_status) { "cancelled" }

        it_behaves_like "payment is unsuccessful with an error"
      end

      context "when the GovpayPaymentDetailsService raises an error" do
        before { allow(payment_details_service).to receive(:govpay_payment_status).and_raise(StandardError) }

        let(:payment_status) { "success" }

        it_behaves_like "payment is unsuccessful with an error"
      end

      context "when the transient registration is not found" do
        before do
          allow(TransientRegistration).to receive(:where).and_return(TransientRegistration.where(token: "NOT_EXISTING"))
          allow(Rails.logger).to receive(:error)
        end

        let(:payment_status) { "success" }

        context "when the payment has a successful registration associated with it" do
          let(:registration) { create(:registration, :complete, account: payment.account) }

          before do
            registration.update(contact_email: Faker::Internet.email)
            payment.update!(payment_status: "success")
            order.update(order_owner: payment.account)
          end

          it "redirects to completed-registration page" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            expect(response.location).to match(/completed-registration\?email=#{registration.contact_email.gsub('@', '%40')}/)
          end

          it "does not log an error" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            aggregate_failures do
              expect(Airbrake).not_to have_received(:notify)
              expect(Rails.logger).not_to have_received(:error)
            end
          end
        end

        context "when the payment does not have a successful registration associated with it" do
          it "redirects to new_start_form_path" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            expect(response.location).to match(%r{/start})
          end

          it "does not log an error" do
            get payment_callback_govpay_forms_path(token, payment.payment_uuid)
            aggregate_failures do
              expect(Airbrake).not_to have_received(:notify)
              expect(Rails.logger).not_to have_received(:error)
            end
          end
        end
      end
    end
  end
end
