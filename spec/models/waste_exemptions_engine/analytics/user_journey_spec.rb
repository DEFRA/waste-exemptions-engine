# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  module Analytics

    RSpec.describe UserJourney do

      describe "#complete_journey" do
        let(:transient_registration) { create(:new_registration) }
        let(:journey) { Timecop.freeze(1.hour.ago) { create(:user_journey, token: transient_registration.token) } }
        let(:completion_time) { Time.zone.now }

        before do
          allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false)
          Timecop.freeze(completion_time) { journey.complete_journey(transient_registration) }
        end

        it "updates the completed_at attribute on completion" do
          expect(journey.completed_at).to be_within(1.second).of(completion_time)
        end

        it "sets the completed_route to 'DIGITAL' on completion" do
          expect(journey.completed_route).to eq "DIGITAL"
        end

        it "updates registration data with attributes from the transient registration on completion" do
          expected_attributes = transient_registration.attributes.slice("business_type", "type")
          expect(journey.registration_data).to include(expected_attributes)
        end
      end
    end
  end
end
