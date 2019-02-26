# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationExemption, type: :model do
    describe "public interface" do
      subject(:registration_exemption) { build(:registration_exemption) }

      associations = [:registration, :exemption]

      Helpers::ModelProperties::REGISTRATION_EXEMPTION.each do |property|
        it "responds to property" do
          expect(registration_exemption).to respond_to(property)
        end
      end
    end
  end
end
