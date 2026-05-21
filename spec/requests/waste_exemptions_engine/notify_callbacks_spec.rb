# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "NotifyCallbacks" do

    describe "POST /notify_callback" do
      subject(:callback_request) { post notify_callback_path, headers: headers, params: callback_body }

      let(:callback_body) { file_fixture("notify/delivery_receipt_callback.json").read }
      let(:bearer_token) { "test-bearer-token-123" }
      let(:valid_headers) do
        {
          "Authorization" => "Bearer #{bearer_token}",
          "Content-Type" => "application/json"
        }
      end

      before do
        allow(Airbrake).to receive(:notify)
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with("NOTIFY_CALLBACK_BEARER_TOKEN", nil).and_return(bearer_token)
      end

      shared_examples "fails validation" do
        it { expect { callback_request }.not_to have_enqueued_job(NotifyCallbackJob) }

        it "notifies Airbrake" do
          callback_request
          expect(Airbrake).to have_received(:notify)
        end

        it "returns HTTP 200" do
          callback_request
          expect(response).to have_http_status(:ok)
        end
      end

      context "with no Authorization header" do
        let(:headers) { { "Content-Type" => "application/json" } }

        before { callback_request }

        it_behaves_like "fails validation"
      end

      context "with an invalid bearer token" do
        let(:headers) do
          {
            "Authorization" => "Bearer wrong-token",
            "Content-Type" => "application/json"
          }
        end

        before { callback_request }

        it_behaves_like "fails validation"
      end

      context "with no configured bearer token" do
        let(:headers) { valid_headers }

        before do
          allow(ENV).to receive(:fetch).with("NOTIFY_CALLBACK_BEARER_TOKEN", nil).and_return(nil)
          callback_request
        end

        it_behaves_like "fails validation"
      end

      context "with a valid bearer token" do
        let(:headers) { valid_headers }

        it "returns HTTP 200" do
          callback_request

          expect(response).to have_http_status(:ok)
        end

        it "does not notify Airbrake" do
          callback_request

          expect(Airbrake).not_to have_received(:notify)
        end

        it "enqueues a NotifyCallbackJob" do
          expect { callback_request }.to have_enqueued_job(NotifyCallbackJob).exactly(:once)
        end
      end
    end
  end
end
