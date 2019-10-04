# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ContactPhoneForm, type: :model do
    subject(:form) { build(:contact_phone_form) }

    it "validates the phone number using the PhoneNumberValidator class" do
      validators = build(:contact_phone_form)._validators
      expect(validators.keys).to include(:contact_phone)
      expect(validators[:contact_phone].first.class)
        .to eq(DefraRuby::Validators::PhoneNumberValidator)
    end

    it_behaves_like "a validated form", :contact_phone_form do
      let(:valid_params) { { token: form.token, contact_phone: "01234567890" } }
      let(:invalid_params) do
        [
          { token: form.token, contact_phone: "#123" },
          { token: form.token, contact_phone: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the contact phone number" do
          contact_phone = "01234567890"
          valid_params = { token: form.token, contact_phone: contact_phone }
          transient_registration = form.transient_registration

          expect(transient_registration.contact_phone).to be_blank
          form.submit(valid_params)
          expect(transient_registration.contact_phone).to eq(contact_phone)
        end
      end
    end
  end
end
