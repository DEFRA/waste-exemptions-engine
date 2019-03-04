# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#workflow_state" do
      next_state = :operator_postcode_form
      current_state = :operator_name_form
      subject(:transient_registration) { create(:transient_registration, workflow_state: current_state) }

      context "when a TransientRegistration's state is #{current_state}" do
        it "changes to #{next_state} after the 'next' event" do
          expect(transient_registration).to transition_from(current_state).to(next_state).on_event(:next)
        end

        context "when neither transient_registration.partnership? nor " \
        "transient_registration.skip_registration_number? are true" do
          previous_state = :registration_number_form

          %w[limitedCompany limitedLiabilityPartnership].each do |business_type|
            before(:each) { transient_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "can only transition to either #{previous_state} or #{next_state}" do
                permitted_states = transient_registration.aasm.states(permitted: true).map(&:name)
                expect(permitted_states).to match_array([previous_state, next_state])
              end

              it "changes to #{previous_state} after the 'back' event" do
                expect(transient_registration.send(:partnership?)).to eq(false)
                expect(transient_registration.send(:skip_registration_number?)).to eq(false)
                expect(transient_registration).to transition_from(current_state).to(previous_state).on_event(:back)
              end
            end
          end
        end

        context "when transient_registration.partnership? is true" do
          previous_state = :main_people_form

          ["partnership"].each do |business_type|
            before(:each) { transient_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "can only transition to either #{previous_state} or #{next_state}" do
                permitted_states = transient_registration.aasm.states(permitted: true).map(&:name)
                expect(permitted_states).to match_array([previous_state, next_state])
              end

              it "changes to #{previous_state} after the 'back' event" do
                expect(transient_registration.send(:partnership?)).to eq(true)
                expect(transient_registration.send(:skip_registration_number?)).to eq(true)
                expect(transient_registration).to transition_from(current_state).to(previous_state).on_event(:back)
              end
            end
          end
        end

        context "when transient_registration.skip_registration_number? is true" do
          previous_state = :business_type_form

          %w[localAuthority charity soleTrader].each do |business_type|
            before(:each) { transient_registration.business_type = business_type }

            context "and the business type is #{business_type}" do
              it "can only transition to either #{previous_state} or #{next_state}" do
                permitted_states = transient_registration.aasm.states(permitted: true).map(&:name)
                expect(permitted_states).to match_array([previous_state, next_state])
              end

              it "changes to #{previous_state} after the 'back' event" do
                expect(transient_registration.send(:partnership?)).to eq(false)
                expect(transient_registration.send(:skip_registration_number?)).to eq(true)
                expect(transient_registration).to transition_from(current_state).to(previous_state).on_event(:back)
              end
            end
          end
        end
      end
    end
  end
end
