# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistrationExemption, type: :model do
    describe "public interface" do
      subject(:transient_registration_exemption) { build(:transient_registration_exemption) }

      associations = %i[transient_registration exemption]

      (Helpers::ModelProperties::REGISTRATION_EXEMPTION + associations).each do |property|
        it "responds to property" do
          expect(transient_registration_exemption).to respond_to(property)
        end
      end
    end
  end
end
