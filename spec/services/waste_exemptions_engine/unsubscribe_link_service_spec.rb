# frozen_string_literal: true

require "rails_helper"
module WasteExemptionsEngine
  RSpec.describe UnsubscribeLinkService do
    let(:registration) { create(:registration) }
    let(:service) { described_class.new }

    describe "run" do
      before do
        @unsubscribe_link = service.run(registration: registration)
      end

      it "returns a link to the front office" do
        expect(@unsubscribe_link).to start_with(Rails.configuration.front_office_url)
      end

      it "returns a link to the unsubscribe path" do
        expect(@unsubscribe_link).to include("registrations/unsubscribe")
      end

      it "returns a link with the correct token" do
        expect(@unsubscribe_link).to include(registration.unsubscribe_token)
      end
    end
  end
end
