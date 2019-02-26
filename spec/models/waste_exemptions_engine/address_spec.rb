# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Address, type: :model do
    describe "public interface" do
      subject(:address) { build(:address) }

      associations = [:registration]

      (Helpers::ModelProperties::ADDRESS + associations).each do |property|
        it "responds to property" do
          expect(address).to respond_to(property)
        end
      end
    end
  end
end
