# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Band do
    describe "public interface" do
      subject(:band) { build(:band) }

      Helpers::ModelProperties::BAND.each do |property|
        it "responds to property" do
          expect(band).to respond_to(property)
        end
      end
    end
  end
end
