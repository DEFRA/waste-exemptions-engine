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
    it_behaves_like "it has PaperTrail", :registration, :operator_name
  end
end
