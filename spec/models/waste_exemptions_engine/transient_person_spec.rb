# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientPerson do
    subject(:transient_person) { build(:transient_person) }

    describe "public interface" do
      associations = [:transient_registration]

      (Helpers::ModelProperties::PERSON + associations).each do |property|
        it "responds to property" do
          expect(transient_person).to respond_to(property)
        end
      end
    end

    describe "#person_attributes" do
      it "returns attributes specific to defining a person" do
        attributes = transient_person.person_attributes
        expect(attributes.keys).to match_array(Helpers::ModelProperties::PERSON.map(&:to_s))
      end
    end
  end
end
