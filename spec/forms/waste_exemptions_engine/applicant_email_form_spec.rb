# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ApplicantEmailForm, type: :model do
    subject(:form) { build(:applicant_email_form) }

    describe "validations" do
      subject(:validators) { form._validators }

      describe "email attribute validation" do
        it "validates the applicant email using the EmailValidator class" do
          expect(validators.keys).to include(:applicant_email)
          expect(validators[:applicant_email].first.class)
            .to eq(DefraRuby::Validators::EmailValidator)
        end

        it "validates the confirmed email using the EmailValidator class" do
          expect(validators.keys).to include(:confirmed_email)
          expect(validators[:confirmed_email].map(&:class))
            .to include(DefraRuby::Validators::EmailValidator)
        end
      end

      describe "matching email validation" do
        it "validates the applicant email and confirmed email using the MatchingEmailValidator class " do
          expect(validators.keys).to include(:confirmed_email)

          matching_email_validators = validators[:confirmed_email].select do |v|
            v.class == WasteExemptionsEngine::MatchingEmailValidator
          end
          expect(matching_email_validators.count).to eq(1)
          expect(matching_email_validators.first.options).to eq(compare_to: :applicant_email)
        end
      end
    end

    it_behaves_like "a validated form", :applicant_email_form do
      let(:valid_params) do
        { applicant_email: "test@example.com", confirmed_email: "test@example.com" }
      end
      let(:invalid_params) do
        [
          { applicant_email: "test@example.com", confirmed_email: "different@example.com" },
          { applicant_email: "", confirmed_email: "test@example.com" },
          { applicant_email: "test@example.com", confirmed_email: "" },
          { applicant_email: "", confirmed_email: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the applicant email address" do
          email = "test@example.com"
          valid_params = { applicant_email: email, confirmed_email: email }
          transient_registration = form.transient_registration

          expect(transient_registration.applicant_email).to be_blank
          form.submit(valid_params)
          expect(transient_registration.applicant_email).to eq(email)
        end
      end
    end
  end
end
