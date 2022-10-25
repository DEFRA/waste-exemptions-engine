# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationExemption do
    describe "public interface" do
      subject(:registration_exemption) { build(:registration_exemption) }

      associations = %i[registration exemption]

      (Helpers::ModelProperties::REGISTRATION_EXEMPTION + associations).each do |property|
        it "responds to property" do
          expect(registration_exemption).to respond_to(property)
        end
      end
    end

    describe "#order_by_state_then_id" do
      let(:registration) do
        registration = create(:registration, registration_exemptions: [])
        5.times do
          %i[active ceased revoked expired].each do |state|
            create(
              :registration_exemption,
              registration: registration,
              exemption: build(:exemption),
              state: state
            )
          end
        end
        registration
      end

      it "returns the registration exemptions in a specific order of states and then by exemption id" do
        sorted_registration_exemptions = registration.registration_exemptions.order_by_state_then_exemption_id
        # --- Confirm the States are in the expected order ---
        # We need to use chunk_while instead of uniq to confirm the states are sorted as uniq could
        # pass the test but fail the expectation.
        grouped_states = sorted_registration_exemptions.map(&:state).chunk_while { |a, b| a == b }.to_a
        expect(grouped_states.count).to eq(4) # This can only be the case if the states are ordered.
        expect(grouped_states.flatten.uniq).to eq(%w[active ceased revoked expired]) # The correct order

        # --- Confirm the IDs are sequential for each state ---
        sorted_states_and_ids = sorted_registration_exemptions.map { |re| [re.state, re.exemption_id] }
        # Group the IDs for each state so we confirm the ids for each group are sequential
        grouped_ids = sorted_states_and_ids.group_by(&:first).map { |_state, state_id_pairs| state_id_pairs.map(&:last) }
        expect(grouped_ids.count).to eq(4) # Confirm there are the same number of groups as states
        grouped_ids.each do |ids|
          expect(ids.sort).to eq(ids)
        end
      end
    end
  end
end
