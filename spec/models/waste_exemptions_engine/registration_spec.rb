# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Registration do
    describe "public interface" do
      subject(:registration) { build(:registration) }

      Helpers::ModelProperties::REGISTRATION.each do |property|
        it "responds to property" do
          expect(registration).to respond_to(property)
        end
      end
    end

    it_behaves_like "an owner of registration attributes", :registration, :address

    describe "associations" do
      subject(:registration) { create(:registration, :complete) }

      describe "#site_address" do
        it "returns an Address of type :site" do
          site_address = registration.addresses.find_by(address_type: 3)
          expect(registration.site_address).to eq(site_address)
        end
      end

      describe "#operator_address" do
        it "returns an Address of type :operator" do
          operator_address = registration.addresses.find_by(address_type: 1)
          expect(registration.operator_address).to eq(operator_address)
        end
      end

      describe "#contact_address" do
        it "returns an Address of type :contact" do
          contact_address = registration.addresses.find_by(address_type: 2)
          expect(registration.contact_address).to eq(contact_address)
        end
      end
    end

    describe "#renewal?" do
      subject(:registration) { create(:registration) }

      context "when a referring registration is present" do
        before do
          create(:registration, referred_registration: registration)
        end

        it "returns true" do
          expect(registration).to be_a_renewal
        end
      end

      context "when a referring registration is not present" do
        it "returns false" do
          expect(registration).not_to be_a_renewal
        end
      end
    end

    describe "#already_renewed?" do
      subject(:registration) { create(:registration) }

      context "when a referring registration is present" do
        before do
          create(:registration, referring_registration_id: registration.id)
        end

        it "returns true" do
          expect(registration).to be_already_renewed
        end
      end

      context "when a referring registration is not present" do
        it "returns false" do
          expect(registration).not_to be_already_renewed
        end
      end
    end

    describe "#active_exemptions" do
      subject(:registration) { create(:registration, :with_active_exemptions) }

      it "returns a list of registrations in an active status" do
        pending_exemption = registration.registration_exemptions.first
        pending_exemption.state = :pending
        pending_exemption.save

        expect(registration.active_exemptions.count).to eq(registration.exemptions.count - 1)
      end
    end

    describe "#expired_exemptions" do
      subject(:registration) { create(:registration, :with_expired_exemptions) }

      it "returns a list of registrations in an expired status" do
        pending_exemption = registration.registration_exemptions.first
        pending_exemption.state = :pending
        pending_exemption.save

        expect(registration.expired_exemptions.count).to eq(registration.exemptions.count - 1)
      end
    end

    describe "#expired_and_active_exemptions" do
      subject(:registration) { create(:registration, :with_expired_and_active_exemptions) }

      it "returns a list of registrations in an active status" do
        pending_exemption = registration.registration_exemptions.first
        pending_exemption.state = :pending
        pending_exemption.save

        expect(registration.expired_and_active_exemptions.count).to eq(registration.exemptions.count - 1)
      end
    end

    describe "#expires_on" do
      subject(:registration) { create(:registration, :with_active_exemptions) }

      before do
        registration.registration_exemptions.first.expires_on = 3.days.from_now
        registration.registration_exemptions.last.expires_on = 2.days.from_now
        registration.save!
      end

      it "returns the expiry date of the first exemption to expire" do
        expect(registration.expires_on).to eq 2.days.from_now.to_date
      end
    end

    describe "#past_renewal_window?" do
      let(:registration_exemption) { build(:registration_exemption, expires_on: expires_on) }

      subject(:registration) { create(:registration, registration_exemptions: [registration_exemption]) }

      before do
        allow(WasteExemptionsEngine.configuration).to receive(:renewal_window_before_expiry_in_days).and_return(28)
        allow(WasteExemptionsEngine.configuration).to receive(:renewal_window_after_expiry_in_days).and_return(30)
      end

      context "when the renewal period hasn't finished yet" do
        let(:expires_on) { 50.days.from_now }

        it "returns false" do
          expect(registration).not_to be_past_renewal_window
        end
      end

      context "when the renewal period has passed" do
        let(:expires_on) { 50.days.ago }

        it "returns true" do
          expect(registration).to be_past_renewal_window
        end
      end

      context "when the registration expired exactly 30 days ago" do
        let(:expires_on) { 30.days.ago }

        it "returns false" do
          expect(registration).not_to be_past_renewal_window
        end
      end
    end

    describe "#in_renewal_window?" do
      let(:registration_exemption) { build(:registration_exemption, expires_on: expires_on) }

      subject(:registration) { create(:registration, registration_exemptions: [registration_exemption]) }

      before do
        allow(WasteExemptionsEngine.configuration).to receive(:renewal_window_before_expiry_in_days).and_return(28)
        allow(WasteExemptionsEngine.configuration).to receive(:renewal_window_after_expiry_in_days).and_return(30)
      end

      context "when the renewal period hasn't started yet" do
        let(:expires_on) { 50.days.from_now }

        it "returns false" do
          expect(registration).not_to be_in_renewal_window
        end
      end

      context "when the renewal period has started" do
        let(:expires_on) { 10.days.from_now }

        it "returns true" do
          expect(registration).to be_in_renewal_window
        end
      end

      context "when the expire date is in the past but still in the grace period" do
        let(:expires_on) { 10.days.ago }

        it "returns true" do
          expect(registration).to be_in_renewal_window
        end
      end

      context "when the grace period has passed" do
        let(:expires_on) { 50.days.ago }

        it "returns false" do
          expect(registration).not_to be_in_renewal_window
        end
      end
    end

    describe "#expiry_month" do
      subject(:registration) { create(:registration, :with_active_exemptions) }

      it "returns the expiry month and year" do
        expected_text = "#{3.years.from_now.strftime('%B')} #{3.years.from_now.year}"

        expect(registration.expiry_month).to eq(expected_text)
      end

      context "when there's no valid expiry date" do
        subject(:registration) { create(:registration) }

        it "returns nil" do
          expect(registration.expiry_month).to be_nil
        end
      end
    end

    describe "#received_comms?" do
      let(:registration) { create(:registration) }
      let(:reg_comms_logs) { registration.communication_logs }
      let(:target_label) { "Target label" }
      let(:target_log) { create(:communication_log, template_label: target_label) }
      let(:other_log) { create(:communication_log, template_label: "Other label") }

      before { reg_comms_logs << other_log }

      context "when a message of the relevant type has not been sent" do
        it { expect(registration.received_comms?(target_label)).to be false }
      end

      context "when a message of the relevant type has been sent" do
        before { reg_comms_logs << create(:communication_log, template_label: target_label) }

        it { expect(registration.received_comms?(target_label)).to be true }
      end
    end

    describe "#deregistered?" do
      let(:registration) { create(:registration, :with_expired_and_active_exemptions) }

      context "when not all exepmtion are ceased or revoked" do
        it { expect(registration.deregistered?).to be false }
      end

      context "when all exepmtion are ceased or revoked" do
        before { registration.registration_exemptions.update_all(state: %i[ceased revoked].sample) }

        it { expect(registration.deregistered?).to be true }
      end
    end

    describe "PaperTrail", versioning: true do
      subject(:registration) { create(:registration, :complete) }

      it "has PaperTrail" do
        expect(PaperTrail).to be_enabled
      end

      it "is versioned" do
        expect(registration).to be_versioned
      end

      it "creates a new version when it is updated" do
        expect { registration.update_attribute(:operator_name, Faker::Company.name) }.to change { registration.versions.count }.by(1)
      end

      it "stores the correct values when it is updated" do
        operator_name = Faker::Company.name

        registration.operator_name = operator_name
        registration.paper_trail.save_with_version

        expect(registration.versions.last.reify.operator_name).to eq(operator_name)
      end

      describe "JSON" do
        it "includes the registration's attributes" do
          operator_name = Faker::Company.name

          registration.operator_name = operator_name
          registration.paper_trail.save_with_version

          expect(registration.versions.last.json.to_s).to include(operator_name)
        end

        it "includes related addresses in the JSON" do
          street_address = Faker::Address.street_address

          registration.contact_address.update(street_address: street_address)
          registration.reload.paper_trail.save_with_version

          expect(registration.versions.last.json.to_s).to include(street_address)
        end

        it "includes related people in the JSON" do
          first_name = Faker::Name.first_name

          registration.people.first.update(first_name: first_name)
          registration.paper_trail.save_with_version

          expect(registration.versions.last.json.to_s).to include(first_name)
        end

        it "includes related registration_exemptions in the JSON" do
          expected_message = Faker::Lorem.sentence

          registration.registration_exemptions.first.update(deregistration_message: expected_message)
          registration.paper_trail.save_with_version

          expect(registration.versions.last.json.to_s).to include(expected_message)
        end
      end
    end
  end
end
