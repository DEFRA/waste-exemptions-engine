# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewingRegistration, type: :model do
    subject(:renewing_registration) { create(:renewing_registration) }

    it_behaves_like "a transient_registration", :renewing_registration

    it "subclasses TransientRegistration" do
      expect(described_class).to be < TransientRegistration
    end

    describe "public interface" do
      Helpers::ModelProperties::TRANSIENT_REGISTRATION.each do |property|
        it "responds to property" do
          expect(renewing_registration).to respond_to(property)
        end
      end
    end
  end
end
