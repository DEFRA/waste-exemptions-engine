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
      let(:form) { instance_double(RegistrationCompleteForm, applicant_email: applicant_email, contact_email: contact_email) }

      context "when applicant and contact emails are different" do
        let(:applicant_email) { "applicant_email@test.com" }
        let(:contact_email) { "contact_email@test.com" }

        context "when the applicant email is blank (AD)" do
          let(:applicant_email) { nil }

          it "returns the string `contact_email`" do
            expect(helper.confirmation_comms(form)).to eq("contact_email")
          end
        end

        context "when the contact email is blank (AD)" do
          let(:contact_email) { nil }

          it "returns the string `applicant_email`" do
            expect(helper.confirmation_comms(form)).to eq("applicant_email")
          end
        end

        context "when neither email is the blank (AD)" do
          it "returns the string `both_emails`" do
            expect(helper.confirmation_comms(form)).to eq("both_emails")
          end
        end

        context "when contact email is empty sting" do
          let(:contact_email) { "" }

          it "returns the string 'appliant email" do
            expect(helper.confirmation_comms(form)).to eq("applicant_email")
          end
        end

        context "when applicant email is an empty string" do
          let(:applicant_email) { "" }

          it "returns the string 'contact_email'" do
            expect(helper.confirmation_comms(form)).to eq("contact_email")
          end
        end
      end

      context "when applicant and contact emails are equal" do
        let(:applicant_email) { "applicant_email@test.com" }
        let(:contact_email) { applicant_email }

        context "when both emails are blank (AD)" do
          let(:applicant_email) { nil }

          it "returns the string `letter`" do
            expect(helper.confirmation_comms(form)).to eq("letter")
          end
        end

        context "when neither email is the AD email" do
          it "returns the string `both_emails`" do
            expect(helper.confirmation_comms(form)).to eq("contact_email")
          end
        end
      end
    end
  end
end
