# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe PluralsHelper do
    describe "#exemptions_plural" do
      let(:form) { instance_double(RegistrationCompleteForm, exemptions: exemptions) }

      context "when there is more than one exemption" do
        let(:exemptions) { %i[exemption_1 exemption_2] }

        it "returns the string `many`" do
          expect(helper.exemptions_plural(form)).to eq("many")
        end
      end

      context "when there is only one exemption" do
        let(:exemptions) { [:exemption] }

        it "returns the string `one`" do
          expect(helper.exemptions_plural(form)).to eq("one")
        end
      end
    end

    describe "#confirmation_comms" do
      let(:form) { instance_double(RegistrationCompleteForm, contact_email: contact_email) }

      context "when the contact email is present" do
        let(:contact_email) { "contact_email@test.com" }

        it "returns the string `contact_email`" do
          expect(helper.confirmation_comms(form)).to eq("contact_email")
        end
      end

      context "when the contact email is nil" do
        let(:contact_email) { nil }

        it "returns the string `letter`" do
          expect(helper.confirmation_comms(form)).to eq("letter")
        end
      end

      context "when the contact email is an empty string" do
        let(:contact_email) { "" }

        it "returns the string `letter`" do
          expect(helper.confirmation_comms(form)).to eq("letter")
        end
      end
    end
  end
end
