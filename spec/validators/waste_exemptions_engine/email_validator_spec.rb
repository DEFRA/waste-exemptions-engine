# frozen_string_literal: true

require "rails_helper"

module Test
  EmailValidatable = Struct.new(:email) do
    include ActiveModel::Validations

    validates :email, "waste_exemptions_engine/email": true
  end
end

module WasteExemptionsEngine
  RSpec.describe EmailValidator, type: :model do
    valid_email = "test@example.com"
    invalid_email = "foo@bar"

    it_behaves_like "a validator", Test::EmailValidatable, :email, valid_email
    it_behaves_like "a presence validator", Test::EmailValidatable, :email

    describe "#validate_each" do
      context "when the email is not valid" do
        context "because the email is not correctly formatted" do
          validatable = Test::EmailValidatable.new(invalid_email)
          error_message = Helpers::Translator.error_message(validatable, :email, :invalid_format)

          it_behaves_like "an invalid record", validatable, :email, error_message
        end
      end
    end
  end
end
