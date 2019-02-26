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

    # TransientRegistration (CanHaveRegistrationAttributes, CanChangeWorkflowStatus; 1 public method and 2 private methods)
  end
end
