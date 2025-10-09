# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NewRegistration do
    subject(:new_registration) { create(:new_registration) }

    describe "#next_state!" do
      let(:new_registration) { build(:new_registration) }

      subject(:next_state) { new_registration.next_state! }

      context "with no available next state" do
        before { new_registration.workflow_state = "registration_complete_form" }

        it "does not change the state" do
          expect { next_state }.not_to change(new_registration, :workflow_state)
        end

        it "does not add to workflow history" do
          expect { next_state }.not_to change(new_registration, :workflow_history)
        end
      end

      context "with an invalid state" do
        before { new_registration.workflow_state = "not_valid" }

        it "does not change the state" do
          expect { next_state }.not_to change(new_registration, :workflow_state)
        end

        it "does not add to workflow history" do
          expect { next_state }.not_to change(new_registration, :workflow_history)
        end
      end

      context "with a valid state" do
        before { new_registration.workflow_state = "location_form" }

        it "changes the state" do
          expect { next_state }.to change(new_registration, :workflow_state).to("exemptions_form")
        end

        it "adds to workflow history" do
          expect { next_state }.to change { new_registration.workflow_history.length }.from(0).to(1)
        end

        it "adds the previous state to workflow history" do
          expect { next_state }.to change(new_registration, :workflow_history).to(["location_form"])
        end
      end
    end

    describe "#site_count" do
      let(:transient_registration) { create(:new_registration, :with_all_addresses) }

      context "when is_multisite_registration is true" do
        before { transient_registration.update(is_multisite_registration: true) }

        it "returns the count of site addresses" do
          create(:transient_address, :site_address, transient_registration: transient_registration)
          create(:transient_address, :site_address, transient_registration: transient_registration)
          expect(transient_registration.site_count).to eq(3) # includes the one from factory
        end
      end

      context "when is_multisite_registration is false" do
        before { transient_registration.update(is_multisite_registration: false) }

        it "returns 1 regardless of site addresses count" do
          create(:transient_address, :site_address, transient_registration: transient_registration)
          create(:transient_address, :site_address, transient_registration: transient_registration)
          expect(transient_registration.site_count).to eq(1)
        end
      end
    end

    describe "#previous_valid_state!" do
      let(:new_registration) { build(:new_registration) }

      subject(:previous_valid_state) { new_registration.previous_valid_state! }

      context "with no workflow history" do
        before do
          new_registration.workflow_history = []
          new_registration.workflow_state = "location_form"
        end

        it "uses the default state" do
          expect { previous_valid_state }.to change(new_registration, :workflow_state).to("start_form")
        end

        it "does not modify workflow history" do
          expect { previous_valid_state }.not_to change(new_registration, :workflow_history)
        end
      end

      context "with partially invalid workflow history" do
        before { new_registration.workflow_history = %w[another_form location_form not_valid] }

        it "skips the invalid state" do
          expect { previous_valid_state }.to change(new_registration, :workflow_state).to("location_form")
        end

        it "deletes multiple items workflow history" do
          expect { previous_valid_state }.to change { new_registration.workflow_history.length }.by(-2)
        end
      end

      context "with fully invalid workflow history" do
        before do
          new_registration.workflow_state = "location_form"
          new_registration.workflow_history = %w[no_start_form not_valid]
        end

        it "uses the default state" do
          expect { previous_valid_state }.to change(new_registration, :workflow_state).to("start_form")
        end

        it "deletes all items from workflow history" do
          expect { previous_valid_state }.to change { new_registration.workflow_history.length }.to(0)
        end
      end

      context "with valid workflow history" do
        before do
          new_registration.workflow_history = %w[start_form location_form]
          new_registration.workflow_state = "exemptions_form"
        end

        it "changes the state" do
          expect { previous_valid_state }.to change(new_registration, :workflow_state).to("location_form")
        end

        it "deletes from workflow history" do
          expect { previous_valid_state }.to change { new_registration.workflow_history.length }.by(-1)
        end
      end

      context "when the current state is also in the workflow history" do
        before do
          new_registration.workflow_history = %w[start_form location_form location_form]
          new_registration.workflow_state = "location_form"
        end

        it "skips the duplicated state" do
          expect { previous_valid_state }.to change(new_registration, :workflow_state).to("start_form")
        end

        it "deletes from workflow history" do
          expect { previous_valid_state }.to change { new_registration.workflow_history.length }.to(0)
        end
      end
    end

    describe "#charged?" do
      context "when registration is not charged" do
        let(:new_registration) { build(:new_registration) }

        it { expect(new_registration).not_to be_charged }
      end

      context "when registration is charged" do
        let(:new_registration) { build(:new_charged_registration) }

        it { expect(new_registration).to be_charged }
      end
    end

    describe "#new?" do
      it { expect(build(:new_registration).new?).to be true }
      it { expect(build(:new_charged_registration).new?).to be true }
      it { expect(build(:renewing_registration).new?).to be false }
      it { expect(build(:front_office_edit_registration).new?).to be false }
      it { expect(build(:back_office_edit_registration).new?).to be false }
    end

    describe "#multisite?" do
      let(:transient_registration) { build(:new_registration) }

      context "when is_multisite_registration is false" do
        before do
          transient_registration.is_multisite_registration = false
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
        end

        it "returns false" do
          expect(transient_registration.multisite?).to be false
        end
      end

      context "when is_multisite_registration is true but feature toggle is disabled" do
        before do
          transient_registration.is_multisite_registration = true
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(false)
        end

        it "returns false" do
          expect(transient_registration.multisite?).to be false
        end
      end

      context "when is_multisite_registration is true and feature toggle is enabled" do
        before do
          transient_registration.is_multisite_registration = true
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
        end

        it "returns true" do
          expect(transient_registration.multisite?).to be true
        end
      end

      context "when is_multisite_registration is nil" do
        before do
          transient_registration.is_multisite_registration = nil
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
        end

        it "returns false" do
          expect(transient_registration.multisite?).to be false
        end
      end

      context "when transient_registration is a non-charged registration" do
        let(:transient_registration) { build(:new_registration) }

        it "returns false (base implementation)" do
          expect(transient_registration.multisite?).to be false
        end
      end
    end

    describe "associations" do
      subject(:transient_registration) { create(:new_registration, :complete) }

      describe "#site_address" do
        it "returns a TransientAddress of type :site" do
          site_address = transient_registration.transient_addresses.find_by(address_type: 3)
          expect(transient_registration.site_address).to eq(site_address)
        end
      end

      describe "#site_addresses" do
        it "includes site addresses" do
          site_address_a = create(:transient_address, address_type: 3, transient_registration: transient_registration)
          site_address_b = create(:transient_address, address_type: 3, transient_registration: transient_registration)
          expect(transient_registration.site_addresses).to include(site_address_a, site_address_b)
        end

        it "excludes non-site addresses" do
          create(:transient_address, address_type: 3, transient_registration: transient_registration)
          contact_address = create(:transient_address, address_type: 2, transient_registration: transient_registration)
          expect(transient_registration.site_addresses).not_to include(contact_address)
        end
      end

      describe "#operator_address" do
        it "returns a TransientAddress of type :operator" do
          operator_address = transient_registration.transient_addresses.find_by(address_type: 1)
          expect(transient_registration.operator_address).to eq(operator_address)
        end
      end

      describe "#contact_address" do
        it "returns a TransientAddress of type :contact" do
          contact_address = transient_registration.transient_addresses.find_by(address_type: 2)
          expect(transient_registration.contact_address).to eq(contact_address)
        end
      end
    end
  end
end
