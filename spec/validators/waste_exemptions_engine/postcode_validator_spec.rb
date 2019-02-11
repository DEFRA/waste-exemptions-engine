# frozen_string_literal: true

require "rails_helper"

module Test
  PostcodeValidatable = Struct.new(:postcode) do
    include ActiveModel::Validations

    validates :postcode, "waste_exemptions_engine/postcode": true
  end
end

module WasteExemptionsEngine
  RSpec.describe PostcodeValidator, type: :model do
    let(:valid_postcode) { "BS1 5AH" }
    let(:invalid_postcode) { "foo" }
    let(:postcode_without_addresses) { "AA1 1AA" }

    subject(:validatable) { Test::PostcodeValidatable.new(valid_postcode) }

    describe "#validate_each" do
      context "when the postcode is valid" do
        before(:context) { VCR.insert_cassette("postcode_valid") }
        after(:context) { VCR.eject_cassette }

        it "gets called" do
          expect_any_instance_of(PostcodeValidator)
            .to receive(:validate_each)
            .once

          validatable.valid?
        end

        it "the errors are empty" do
          validatable.valid?
          expect(validatable.errors).to be_empty
        end
      end

      context "when the postcode is not valid" do
        it "there is a validation error" do
          validatable.postcode = invalid_postcode
          validatable.valid?
          expect(validatable.errors[:postcode].count).to eq(1)
        end
      end
    end

    describe "#value_is_present?" do
      subject(:validatable) { Test::PostcodeValidatable.new }

      context "when the postcode is not present" do
        it "gets called" do
          expect_any_instance_of(PostcodeValidator)
            .to receive(:value_is_present?)
            .once

          validatable.valid?
        end

        it "there is an appropriate validation error" do
          validatable.valid?
          expect(validatable.errors[:postcode]).to eq(["Enter a postcode"])
        end
      end
    end

    describe "#value_uses_correct_format?" do
      subject(:validatable) { Test::PostcodeValidatable.new(invalid_postcode) }

      context "when the postcode is not correctly formated" do
        it "gets called" do
          expect_any_instance_of(PostcodeValidator)
            .to receive(:value_uses_correct_format?)
            .once

          validatable.valid?
        end

        it "there is an appropriate validation error" do
          validatable.valid?
          expect(validatable.errors[:postcode]).to eq(["Enter a valid UK postcode"])
        end
      end
    end

    describe "#postcode_returns_results?" do
      context "when the postcode has associated adresses" do
        before(:context) { VCR.insert_cassette("postcode_valid") }
        after(:context) { VCR.eject_cassette }

        it "gets called" do
          expect_any_instance_of(PostcodeValidator)
            .to receive(:postcode_returns_results?)
            .once

          validatable.valid?
        end

        it "the errors are empty" do
          validatable.valid?
          expect(validatable.errors).to be_empty
        end
      end

      context "when the postcode does not have associated adresses" do
        subject(:validatable) do
          Test::PostcodeValidatable.new(postcode_without_addresses)
        end

        before(:context) { VCR.insert_cassette("postcode_no_matches") }
        after(:context) { VCR.eject_cassette }

        it "gets called" do
          expect_any_instance_of(PostcodeValidator)
            .to receive(:postcode_returns_results?)
            .once

          validatable.valid?
        end

        it "there is an appropriate validation error" do
          no_results_error = "We cannot find any addresses for that postcode. " \
            "Check the postcode or enter the address manually."
          validatable.valid?
          expect(validatable.errors[:postcode]).to eq([no_results_error])
        end
      end
    end

    describe "#error_message" do
      subject(:validator) { PostcodeValidator.new(attributes: :postcode) }

      it "returns an appropriate error message for the given error" do
        message_mapping = {
          "blank": "Enter a postcode",
          "wrong_format": "Enter a valid UK postcode",
          "no_results": "We cannot find any addresses for that postcode. " \
            "Check the postcode or enter the address manually."
        }

        message_mapping.each do |error_type, error_message|
          msg = validator.send(:error_message, validatable, :postcode, error_type)
          expect(msg).to eq(error_message)
        end
      end
    end
  end
end
