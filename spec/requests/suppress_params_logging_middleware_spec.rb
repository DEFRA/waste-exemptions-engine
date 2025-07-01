# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe SuppressParamsLoggingMiddleware do

    before do
      allow(Rails.logger).to receive(:fatal) # .and_call_original
      allow(Rails.logger).to receive(:error) # .and_call_original
      allow(Rails.logger).to receive(:warn) # .and_call_original
      allow(Rails.logger).to receive(:info).and_call_original ### this to enable output to test.log
      allow(Rails.logger).to receive(:debug) # .and_call_original
      allow(Rails.logger).to receive(:unknown) # .and_call_original
    end

    it "does not suppress logging for routes not specified for suppression" do
      post new_site_postcode_form_path(token: "foo"), params: { temp_site_postcode: "BS1 5AH" }

      expect(Rails.logger).to have_received(:info).with(/Parameters: .*temp_site_postcode.*BS1 5AH/)
    end

    it "suppresses logging for a route specified for suppression" do
      post process_govpay_webhook_path, params: { foo: :bar }

      expect(Rails.logger).not_to have_received(:info).with(/Parameters:/)
    end
  end
end
