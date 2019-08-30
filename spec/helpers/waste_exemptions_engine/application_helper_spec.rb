# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ApplicationHelper, type: :helper do
    describe "#format_names" do
      it "concatenates first and last name into a full name" do
        expect(helper.format_names("Fiona", "Laurel")).to eq("Fiona Laurel")
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
