# frozen_string_literal: true

require "rails_helper"

module Test
  TokenValidatable = Struct.new(:token) do
    include ActiveModel::Validations

    validates :token, "waste_exemptions_engine/token": true
  end
end

module WasteExemptionsEngine
  RSpec.describe TokenValidator, type: :model do
    valid_token = "123456" * 4 # The token must be 24 characters
    invalid_token = "123456"

    it_behaves_like "a validator", Test::TokenValidatable, :token, valid_token

    describe "#validate_each" do
      context "when the token is not valid" do
        context "because the token is not correctly formatted" do
          validatable = Test::TokenValidatable.new(invalid_token)
          error_message = Helpers::Translator.error_message(validatable, :token, :invalid_format)

          it_behaves_like "an invalid record", validatable, :token, error_message
        end
      end
    end
  end
end
