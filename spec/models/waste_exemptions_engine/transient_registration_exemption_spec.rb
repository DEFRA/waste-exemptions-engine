# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistrationExemption, type: :model do
    subject(:transient_registration_exemption) { build(:transient_registration_exemption) }

    describe "public interface" do
      associations = %i[transient_registration exemption]

      (Helpers::ModelProperties::TRANSIENT_REGISTRATION_EXEMPTION + associations).each do |property|
        it "responds to property" do
          expect(transient_registration_exemption).to respond_to(property)
        end
      end
    end

    describe "#exemption_attributes" do
      it "returns attributes specific to defining an exemption" do
        attributes = transient_registration_exemption.exemption_attributes
        exemption_attributes = Helpers::ModelProperties::TRANSIENT_REGISTRATION_EXEMPTION.map(&:to_s) + ["exemption_id"]
        expect(attributes.keys).to match_array(exemption_attributes)
      end
    end

    it_behaves_like "a changer of the exemption status", :transient_registration_exemption
  end
end
