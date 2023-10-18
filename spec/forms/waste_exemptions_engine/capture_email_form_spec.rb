# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CaptureEmailForm, type: :model do
    subject(:form) { build(:capture_email_form, contact_email: contact_email) }
    let(:contact_email) { "foo@example.com" }
    let(:params) { { contact_email: contact_email } }

    it "validates the contact_email field using the DefraRuby::Validators::EmailValidator class" do
      validators = form._validators
      expect(validators[:contact_email].first.class).to eq(DefraRuby::Validators::EmailValidator)
    end

    shared_examples "submits and populates the contact_email" do
      it "submits the form successfully" do
        expect(form.submit(ActionController::Parameters.new(params))).to be true
      end

      it "populates the contact_email" do
        expect { form.submit(ActionController::Parameters.new(params)) }
          .to change { form.transient_registration.contact_email }.to(contact_email.strip)
      end
    end

    shared_examples "does not submit" do
      it "does not submit the form successfully" do
        expect(form.submit(ActionController::Parameters.new(params))).to be false
      end
    end

    context "when the form is valid" do
      before { form.transient_registration.contact_email = nil }

      context "with a vald email address" do
        let(:contact_email) { Faker::Internet.email }

        it_behaves_like "submits and populates the contact_email"
      end

      context "with whitespace around the email address" do
        let(:actual_email) { Faker::Internet.email }
        let(:contact_email) { "  #{actual_email} " }

        it_behaves_like "submits and populates the contact_email"
      end
    end

    context "with an invalid email address" do
      let(:contact_email) { "foo" }

      it_behaves_like "does not submit"
    end
  end
end
