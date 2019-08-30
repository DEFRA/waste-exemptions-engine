# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe PluralsHelper, type: :helper do
    describe "#exemptions_plural" do
      let(:form) { double(:form, exemptions: exemptions) }

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

    describe "#emails_plural" do
      let(:form) { double(:form, applicant_email: applicant_email, contact_email: contact_email) }

      context "when applicant and contact emails are different" do
        let(:applicant_email) { "applicant_email@test.com" }
        let(:contact_email) { "contact_email@test.com" }

        it "returns the string `many`" do
          expect(helper.emails_plural(form)).to eq("many")
        end
      end

      context "when applicant and contact emails are equal" do
        let(:applicant_email) { "applicant_email@test.com" }
        let(:contact_email) { applicant_email }

        it "returns the string `one`" do
          expect(helper.emails_plural(form)).to eq("one")
        end
      end
    end
  end
end
