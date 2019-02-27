# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Person, type: :model do
    describe "public interface" do
      subject(:person) { build(:person) }

      associations = [:registration]

      (Helpers::ModelProperties::PERSON + associations).each do |property|
        it "responds to property" do
          expect(person).to respond_to(property)
        end
      end
    end
  end
end
