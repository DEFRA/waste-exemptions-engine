# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationExemption do
    describe "public interface" do
      subject(:registration_exemption) { build(:registration_exemption) }

      associations = %i[registration exemption address]

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

        aggregate_failures do
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

    describe "PaperTrail", :versioning do
      subject(:registration_exemption) { create(:registration_exemption) }

      shared_examples "creates a new version" do
        it { expect(registration_exemption.versions.count).to eq(1) }
        it { expect(registration_exemption.versions.first.reify.state).to eq("active") }
        it { expect(registration_exemption.versions.first.reify.deregistered_at).to be_nil }
        it { expect(registration_exemption.reload.deregistered_at).not_to be_nil }
      end

      it "is versioned" do
        expect(registration_exemption).to be_versioned
      end

      context "when registration_exemption is expected to be persisted" do
        before do
          # registration_exemption is expected to be persisted when deregistered_at is set
          registration_exemption.update(state: "revoked", deregistration_message: "foo", deregistered_at: Time.zone.now)
        end

        it_behaves_like "creates a new version"
      end

      context "when performing a regular update" do
        before do
          # registration_exemption is not expected to be persisted when deregistered_at not is set
          registration_exemption.update!(deregistration_message: "foo")
        end

        it "does not create a new version" do
          expect(registration_exemption.versions.size).to eq(0)
        end
      end
    end
  end
end
