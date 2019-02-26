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
  end
end