# frozen_string_literal: true

module Test
  MatchingEmailValidatable = Struct.new(:email, :matching_email) do
    include ActiveModel::Validations

    validates :matching_email, "waste_exemptions_engine/matching_email": { compare_to: :email }
  end
end

module WasteExemptionsEngine
  RSpec.describe MatchingEmailValidator, type: :model do
    email = "test@example.com"
    good_match = email
    bad_match = "bad_match@example.com"

    it_behaves_like "a validator", Test::MatchingEmailValidatable, :matching_email, [email, good_match]

    describe "#validate_each" do
      context "when the matching email is not valid" do
        context "because the matching email is not correctly formatted" do
          validatable = Test::MatchingEmailValidatable.new(email, bad_match)
          error_message = Helpers::Translator.error_message(validatable, :matching_email, :does_not_match)

          it_behaves_like "an invalid record", validatable, :matching_email, error_message
        end
      end
    end
  end
end
