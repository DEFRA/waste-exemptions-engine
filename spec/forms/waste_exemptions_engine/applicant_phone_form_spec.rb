# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ApplicantPhoneForm, type: :model do
    subject(:form) { build(:applicant_phone_form) }

    it "validates the phone number using the PhoneNumberValidator class" do
      validators = form._validators
      expect(validators.keys).to include(:applicant_phone)
      expect(validators[:applicant_phone].first.class)
        .to eq(DefraRuby::Validators::PhoneNumberValidator)
    end

    it_behaves_like "a validated form", :applicant_phone_form do
      let(:valid_params) { { applicant_phone: "01234567890" } }
      let(:invalid_params) do
        [
          { applicant_phone: "#123" },
          { applicant_phone: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the applicant phone number" do
          applicant_phone = "01234567890"
          valid_params = { applicant_phone: applicant_phone }
          transient_registration = form.transient_registration

          expect(transient_registration.applicant_phone).to be_blank
          form.submit(valid_params)
          expect(transient_registration.applicant_phone).to eq(applicant_phone)
        end
      end
    end
  end
end
