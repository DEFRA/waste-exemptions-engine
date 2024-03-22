# frozen_string_literal: true

require "rails_helper"
module WasteExemptionsEngine
  RSpec.describe UnsubscribeLinkService do
    let(:registration) { create(:registration) }
    let(:service) { described_class.new }

    describe "run" do
      before do
        @old_token = registration.unsubscribe_token
        @unsubscribe_link = service.run(registration: registration)
      end

      it "generates a new unsubscribe token" do
        expect(registration.unsubscribe_token).not_to eq(@old_token)
      end

      it "returns a link to the front office" do
        expect(@unsubscribe_link).to start_with(Rails.configuration.front_office_url)
      end

      it "returns a link to the unsubscribe path" do
        expect(@unsubscribe_link).to include("registrations/unsubscribe")
      end
    end
  end
end
