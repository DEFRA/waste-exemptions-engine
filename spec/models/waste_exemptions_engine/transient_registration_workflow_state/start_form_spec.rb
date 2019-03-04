# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      current_state = :start_form
      subject(:transient_registration) { create(:transient_registration, workflow_state: current_state) }

      context "when a TransientRegistration's state is #{current_state}" do
        context "when transient_registration.should_contact_the_agency? is true" do
          before(:each) { transient_registration.start_option = "change" }

          it "can only transition to :contact_agency_form" do
            permitted_states = transient_registration.aasm.states(permitted: true).map(&:name)
            expect(permitted_states).to eq([:contact_agency_form])
          end

          it "changes to :contact_agency_form after the 'next' event" do
            expect(transient_registration.send(:should_contact_the_agency?)).to eq(true)
            expect(transient_registration).to transition_from(current_state).to(:contact_agency_form).on_event(:next)
          end
        end

        context "when transient_registration.should_contact_the_agency? is false" do
          it "can only transition to :location_form" do
            permitted_states = transient_registration.aasm.states(permitted: true).map(&:name)
            expect(permitted_states).to eq([:location_form])
          end

          it "changes to :location_form after the 'next' event" do
            expect(transient_registration.send(:should_contact_the_agency?)).to eq(false)
            expect(transient_registration).to transition_from(current_state).to(:location_form).on_event(:next)
          end
        end

        it "is unable to transition when the 'back' event is issued" do
          expect { transient_registration.back }.to raise_error(AASM::InvalidTransition)
        end
      end
    end
  end
end
