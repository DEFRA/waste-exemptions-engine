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
        before(:each) { VCR.insert_cassette("postcode_valid") }
        after(:each) { VCR.eject_cassette }

        it "gets called" do
          expect_any_instance_of(PostcodeValidator)
            .to receive(:validate_each)
            .once

          validatable.valid?
        end

        it "confirms the object is valid" do
          expect(validatable).to be_valid
        end

        it "the errors are empty" do
          validatable.valid?
          expect(validatable.errors).to be_empty
        end
      end

      context "when the postcode is not valid" do
        context "because the postcode is not present" do
          subject(:validatable) { Test::PostcodeValidatable.new }

          it "confirms the object is invalid" do
            expect(validatable).to_not be_valid
          end

          it "adds a single validation error to the record" do
            validatable.valid?
            expect(validatable.errors[:postcode].count).to eq(1)
          end

          it "adds an appropriate validation error" do
            error_msg = Helpers::Translator.error_message(validatable, :postcode, :blank)
            validatable.valid?
            expect(validatable.errors[:postcode]).to eq([error_msg])
          end
        end

        context "because the postcode is not correctly formated" do
          subject(:validatable) { Test::PostcodeValidatable.new(invalid_postcode) }

          it "confirms the object is invalid" do
            expect(validatable).to_not be_valid
          end

          it "adds a single validation error to the record" do
            validatable.valid?
            expect(validatable.errors[:postcode].count).to eq(1)
          end

          it "adds an appropriate validation error" do
            error_msg = Helpers::Translator.error_message(validatable, :postcode, :wrong_format)
            validatable.valid?
            expect(validatable.errors[:postcode]).to eq([error_msg])
          end
        end

        context "because the postcode does not have associated adresses" do
          subject(:validatable) do
            Test::PostcodeValidatable.new(postcode_without_addresses)
          end

          before(:each) { VCR.insert_cassette("postcode_no_matches") }
          after(:each) { VCR.eject_cassette }

          it "confirms the object is invalid" do
            expect(validatable).to_not be_valid
          end

          it "adds a single validation error to the record" do
            validatable.valid?
            expect(validatable.errors[:postcode].count).to eq(1)
          end

          it "adds an appropriate validation error" do
            error_msg = Helpers::Translator.error_message(validatable, :postcode, :no_results)
            validatable.valid?
            expect(validatable.errors[:postcode]).to eq([error_msg])
          end
        end
      end
    end
  end
end
