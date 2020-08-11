# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NotifyService do
    describe "run" do
      let(:email) { "foo@example.com" }
      let(:name) { "Foo" }
      let(:service) { NotifyService.run(email: email, name: name) }

      it "sends an email" do
        VCR.use_cassette("notify_test") do
          args = {
            email_address: email,
            template_id: "4ea25669-1203-4ed7-8f0f-45f0dcaa8199",
            personalisation: { name: name }
          }
          expect_any_instance_of(Notifications::Client).to receive(:send_email).with(args).and_call_original

          response = service

          expect(response).to be_a(Notifications::Client::ResponseNotification)
          expect(response.content["body"]).to eq("This is a test message for Foo.")
        end
      end
    end
  end
end
