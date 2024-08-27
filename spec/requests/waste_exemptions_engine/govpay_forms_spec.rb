# frozen_string_literal: true

require "webmock/rspec"
require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "GovpayForms" do
    let(:govpay_host) { "https://publicapi.payments.service.gov.uk" }
    let(:order) { transient_registration.order }

    before do
      allow(Airbrake).to receive(:notify)
    end

    context "when a valid user is signed in" do
      context "when a valid transient registration exists" do
        let(:transient_registration) do
          create(:new_charged_registration,
                 workflow_state: "govpay_form",
                 workflow_history: ["payment_summary_form"])
        end
        let(:order) { create(:order, :with_charge_detail, order_owner: transient_registration) }
        let(:token) { transient_registration[:token] }

        describe "#new" do

          before do
            stub_request(:any, /.*#{govpay_host}.*/).to_return(
              status: 200,
              body: File.read("./spec/fixtures/files/govpay/get_payment_response_created.json")
            )
            order.charge_detail
          end

          it "creates a new payment" do
            get new_govpay_form_path(token)
            expect(transient_registration.order.reload.payments).to be_present
          end

          it "redirects to govpay" do
            get new_govpay_form_path(token)
            expect(response.location).to include("https://www.payments.service.gov.uk")
          end

          it "populates govpay_id on the payment" do
            get new_govpay_form_path(token)
            expect(transient_registration.order.reload.payments.last.govpay_id).to be_present
          end

          context "when the transient_registration is a new registration" do
            let(:transient_registration) do
              create(:new_charged_registration,
                     workflow_state: "govpay_form")
            end

            it "creates a new payment" do
              get new_govpay_form_path(token)
              expect(transient_registration.order.reload.payments).to be_present
            end
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
          let(:payment) { create(:payment, order: order) }

          before do
            allow(Rails.configuration).to receive(:govpay_url).and_return(govpay_host)
            allow(GovpayPaymentService).to receive(:new).and_return(payment_service)
            allow(payment_service).to receive(:prepare_for_payment)
            allow(GovpayPaymentDetailsService).to receive(:new).and_return(payment_details_service)
            allow(payment_details_service).to receive(:govpay_payment_status).and_return(govpay_status)
            payment
          end

          context "when govpay status is success" do
            let(:govpay_status) { "success" }

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

          context "with pending govpay statuses" do

            RSpec.shared_examples "payment is pending" do

              context "when the payment uuid is valid" do
                before do
                  order.update!(govpay_status: "created")
                end

                it "redirects to renewal_received_pending_govpay_payment_form" do
                  get payment_callback_govpay_forms_path(token, payment.payment_uuid)
                  expect(response).to redirect_to(new_renewal_received_pending_govpay_payment_form_path(token))
                end
              end

              context "when the payment uuid is invalid" do
                it "redirects to payment_summary_form" do
                  get payment_callback_govpay_forms_path(token, "invalid_payment_uuid")
                  expect(response).to redirect_to(new_payment_summary_form_path(token))
                end
              end
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

            let(:govpay_status) { "success" }

            it_behaves_like "payment is unsuccessful with an error"
          end

          context "with an invalid failure status" do
            before { allow(GovpayValidatorService).to receive(:valid_govpay_status?).and_return(false) }

            let(:govpay_status) { "cancelled" }

            it_behaves_like "payment is unsuccessful with an error"
          end
        end
      end
    end
  end
end
