# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientPerson, type: :model do
    describe "public interface" do
      subject(:transient_person) { build(:transient_person) }

      associations = [:transient_registration]

      (Helpers::ModelProperties::PERSON + associations).each do |property|
        it "responds to property" do
          expect(transient_person).to respond_to(property)
        end
      end
    end
  end
end
