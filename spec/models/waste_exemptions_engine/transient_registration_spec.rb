# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    subject(:transient_registration) { create(:transient_registration) }

    describe "public interface" do
      Helpers::ModelProperties::TRANSIENT_REGISTRATION.each do |property|
        it "responds to property" do
          expect(transient_registration).to respond_to(property)
        end
      end
    end

    describe "#token" do
      context "when a transient registration is created" do
        it "has a token" do
          expect(transient_registration.token).not_to be_empty
        end
      end
    end

    describe "#registration_attributes" do
      it "returns attributes specific to defining a registration" do
        attributes = transient_registration.registration_attributes
        registration_attributes = Helpers::ModelProperties::REGISTRATION.map(&:to_s) - ["submitted_at"]
        expect(attributes.keys).to match_array(registration_attributes)
      end
    end

    it_behaves_like "an owner of registration attributes", :transient_registration, :transient_address
  end
end
