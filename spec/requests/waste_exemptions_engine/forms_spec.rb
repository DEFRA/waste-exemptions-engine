# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "FormsController" do
    describe "unhandled exception" do

      subject(:request_with_error) { get request_path }

      let(:registration) { create(:registration, :complete, :in_renewal_window) }
      let(:token) { registration.renew_token }
      let(:request_path) { "/waste_exemptions_engine/renew/#{token}" }

      before do
        allow(Airbrake).to receive(:notify)
        allow(Rails.logger).to receive(:error)
        allow(RenewalStartService).to receive(:new).and_raise(StandardError)
      end

      it "re-raises the exception" do
        expect { request_with_error }.to raise_error(StandardError)
      end

      it "logs the exception in the Rails log" do
        request_with_error
      rescue StandardError
        expect(Rails.logger).to have_received(:error)
      end

      it "sends the exception to Airbrake" do
        request_with_error
      rescue StandardError
        expect(Airbrake).to have_received(:notify).at_least(:once)
      end
    end
  end
end
