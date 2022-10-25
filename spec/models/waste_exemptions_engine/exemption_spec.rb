# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Exemption do
    describe "public interface" do
      subject(:exemption) { build(:exemption) }

      Helpers::ModelProperties::EXEMPTION.each do |property|
        it "responds to property" do
          expect(exemption).to respond_to(property)
        end
      end
    end
  end
end
