# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientAddress, type: :model do
    describe "public interface" do
      subject(:transient_address) { build(:transient_address) }

      associations = [:transient_registration]

      (Helpers::ModelProperties::ADDRESS + associations).each do |property|
        it "responds to property" do
          expect(transient_address).to respond_to(property)
        end
      end
    end
  end
end
