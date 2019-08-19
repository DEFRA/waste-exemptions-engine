# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ContactPhoneForm, type: :model do
    subject(:form) { build(:contact_phone_form) }

    it "validates the phone number using the PhoneNumberValidator class" do
      validators = build(:contact_phone_form)._validators
      expect(validators.keys).to include(:phone_number)
      expect(validators[:phone_number].first.class)
        .to eq(DefraRuby::Validators::PhoneNumberValidator)
    end

    it_behaves_like "a validated form", :contact_phone_form do
      let(:valid_params) { { token: form.token, phone_number: "01234567890" } }
      let(:invalid_params) do
        [
          { token: form.token, phone_number: "#123" },
          { token: form.token, phone_number: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the contact phone number" do
          phone_number = "01234567890"
          valid_params = { token: form.token, phone_number: phone_number }
          transient_registration = form.transient_registration

          expect(transient_registration.contact_phone).to be_blank
          form.submit(valid_params)
          expect(transient_registration.contact_phone).to eq(phone_number)
        end
      end
    end
  end
end
