# frozen_string_literal: true

def assign_webhook_status(status)
  webhook_body["resource"]["state"]["status"] = status
end

RSpec.shared_examples "Govpay webhook services error logging" do

  before do
    allow(Airbrake).to receive(:notify)
    allow(Rails.logger).to receive(:error)
  end

  RSpec.shared_examples "logs an error" do
    it "notifies Airbrake" do
      run_service

      expect(Airbrake).to have_received(:notify)
    rescue StandardError
      # expected exception
    end

    it "writes an error to the Rails log" do
      run_service

      expect(Rails.logger).to have_received(:error)
    rescue StandardError
      # expected exception
    end
  end

  shared_examples "does not log an error" do
    it "does not notify Airbrake" do
      run_service

      expect(Airbrake).not_to have_received(:notify)
    end
  end
end

RSpec.shared_examples "a valid payment status transition" do |old_status, new_status|
  before do
    WasteExemptionsEngine::Payment.last.update(payment_status: old_status)
    assign_webhook_status(new_status)
    allow(Airbrake).to receive(:notify)
    allow(Rails.logger).to receive(:info)
  end

  it "updates the status from #{old_status} to #{new_status}" do
    expect { run_service }.to change { wex_payment.reload.payment_status }.to(new_status)
  end

  it "does not log an error" do
    run_service
    expect(Airbrake).not_to have_received(:notify)
  end

  it "writes an info message to the Rails log" do
    run_service

    expect(Rails.logger).to have_received(:info)
  end
end
