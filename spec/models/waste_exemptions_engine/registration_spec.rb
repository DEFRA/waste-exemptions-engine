# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Registration, type: :model do
    describe "public interface" do
      subject(:registration) { build(:registration) }

      Helpers::ModelProperties::REGISTRATION.each do |property|
        it "responds to property" do
          expect(registration).to respond_to(property)
        end
      end
    end

    it_behaves_like "an owner of registration attributes", :registration, :address

    describe ".active_exemptions" do
      subject(:registration) { create(:registration, :with_active_exemptions) }

      it "returns a list of registrations in an active status" do
        pending_exemption = registration.registration_exemptions.first
        pending_exemption.state = :pending
        pending_exemption.save

        expect(registration.active_exemptions.count).to eq(registration.exemptions.count - 1)
      end
    end

    describe "PaperTrail", versioning: true do
      subject(:registration) { create(:registration) }

      it "has PaperTrail" do
        expect(PaperTrail).to be_enabled
      end

      it "is versioned" do
        expect(registration).to be_versioned
      end

      it "creates a new version when it is updated" do
        expect { registration.update_attribute(:operator_name, "foo") }.to change { registration.versions.count }.by(1)
      end

      it "stores the correct values when it is updated" do
        registration.update_attribute(:operator_name, "foo")
        registration.update_attribute(:operator_name, "bar")
        expect(registration).to have_a_version_with(operator_name: "foo")
      end

      it "stores a JSON record of all the data" do
        expected_json = JSON.parse(registration.to_json)
        registration.paper_trail.save_with_version
        expect(registration.versions.last.json).to eq(expected_json)
      end
    end
  end
end
