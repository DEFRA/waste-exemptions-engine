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
    it_behaves_like "it has PaperTrail", model_factory: :registration,
                                         field: :operator_name

    describe ".active_exemptions" do
      subject(:registration) { create(:registration, :with_active_exemptions) }

      it "returns a list of registrations in an active status" do
        pending_exemption = registration.registration_exemptions.first
        pending_exemption.state = :pending
        pending_exemption.save

        expect(registration.active_exemptions.count).to eq(registration.exemptions.count - 1)
      end
    end
  end
end
