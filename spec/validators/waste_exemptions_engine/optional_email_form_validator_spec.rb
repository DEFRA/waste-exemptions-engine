# frozen_string_literal: true

require "rails_helper"

module Test
  OptionalEmailFormValidatable = Struct.new(:contact_email) do
    include ActiveModel::Validations

    attr_reader :contact_email
    attr_reader :confirmed_email
    attr_reader :no_email_address

    validates_with WasteExemptionsEngine::OptionalEmailFormValidator, attributes: [:contact_email]
  end
end

module WasteExemptionsEngine
  RSpec.describe OptionalEmailFormValidator do

    subject(:validator) { Test::OptionalEmailFormValidatable.new }

    let(:contact_email) { Faker::Internet.email }
    let(:confirmed_email) { contact_email }

    before do
      allow(validator).to receive(:contact_email).and_return(contact_email)
      allow(validator).to receive(:confirmed_email).and_return(confirmed_email)
      allow(validator).to receive(:no_email_address).and_return(no_email_address)
    end

    shared_examples "is valid" do
      it "passes the validity check" do
        expect(validator).to be_valid
      end
    end

    shared_examples "is not valid" do
      it "does not pass the validity check" do
        expect(validator).not_to be_valid
      end
    end

    RSpec.shared_examples "contact email address is required" do
      context "with an email address" do
        let(:contact_email) { Faker::Internet.email }

        it_behaves_like "is valid"
      end

      context "without an email address" do
        let(:contact_email) { nil }

        it_behaves_like "is not valid"
      end

      context "with a matching confirmed email address" do
        let(:confirmed_email) { contact_email }

        it_behaves_like "is valid"
      end

      context "with a mismatched confirmed email address" do
        let(:confirmed_email) { "not@chance.com" }

        it_behaves_like "is not valid"
      end
    end

    context "when running in the front office" do
      before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false) }

      let(:no_email_address) { nil }

      it_behaves_like "contact email address is required"
    end

    context "when running in the back office" do
      before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true) }

      context "with no_email_address set to zero" do
        let(:no_email_address) { "0" }

        it_behaves_like "contact email address is required"
      end

      context "with no_email_address set to nil" do
        let(:no_email_address) { nil }

        it_behaves_like "contact email address is required"
      end

      context "with no_email_address set to one" do
        let(:no_email_address) { "1" }

        context "with an email address" do
          let(:contact_email) { Faker::Internet.email }

          it_behaves_like "is not valid"
        end

        context "without an email address" do
          let(:contact_email) { nil }

          it_behaves_like "is valid"
        end
      end
    end
  end
end
