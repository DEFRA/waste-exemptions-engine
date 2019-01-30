# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistration, type: :model do
    describe "#token" do
      context "when a transient registration is created" do
        let(:transient_registration) { create(:transient_registration) }

        it "has a token" do
          expect(transient_registration.token).not_to be_empty
        end
      end
    end
  end
end
