# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe TransientRegistrationExemption do
    subject(:transient_registration_exemption) { build(:transient_registration_exemption) }

    describe "public interface" do
      associations = %i[transient_registration exemption]

      (Helpers::ModelProperties::TRANSIENT_REGISTRATION_EXEMPTION + associations).each do |property|
        it "responds to property" do
          expect(transient_registration_exemption).to respond_to(property)
        end
      end
    end

    describe "#exemption_attributes" do
      it "returns attributes specific to defining an exemption" do
        attributes = transient_registration_exemption.exemption_attributes
        exemption_attributes = Helpers::ModelProperties::TRANSIENT_REGISTRATION_EXEMPTION.map(&:to_s) + ["exemption_id"]
        expect(attributes.keys).to match_array(exemption_attributes)
      end
    end

    describe "#activate_exemption" do

      it "work around a sonarcloud code coverage issue" do
        transient_registration_exemption.activate_exemption
      end

      it "updates the registration date of the exemption" do
        expect { transient_registration_exemption.activate_exemption }
          .to change(transient_registration_exemption, :registered_on).to(Date.today)
      end

      context "with a new registration" do
        subject(:transient_registration_exemption) do
          build(:transient_registration_exemption, transient_registration: build(:new_registration))
        end

        it "sets the expiration date of the exemption to three years from today minus one day" do
          expect { transient_registration_exemption.activate_exemption }
            .to change(transient_registration_exemption, :expires_on).to(Date.today + 3.years - 1.day)
        end
      end

      context "with a registration renewal" do
        let(:original_exemption) { build(:transient_registration_exemption, expires_on: 2.weeks.from_now) }
        let(:renewing_registration) { build(:renewing_registration, registration_exemptions: [original_exemption]) }

        subject(:transient_registration_exemption) do
          build(:transient_registration_exemption, transient_registration: renewing_registration)
        end

        it "sets the expiration date of the exemption to three years from the original expiration date" do
          expect { transient_registration_exemption.activate_exemption }
            .to change(transient_registration_exemption, :expires_on)
            .to(renewing_registration.registration.expires_on + 3.years)
        end
      end
    end
  end
end
