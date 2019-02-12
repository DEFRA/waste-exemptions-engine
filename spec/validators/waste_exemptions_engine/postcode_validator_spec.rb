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
        subject(:validatable) { Test::PostcodeValidatable.new(invalid_postcode) }

        it "adds a validation error to the record" do
          validatable.valid?
          expect(validatable.errors[:postcode].count).to eq(1)
        end

        context "because the postcode is not present" do
          subject(:validatable) { Test::PostcodeValidatable.new }

          it "adds an appropriate validation error" do
            validatable.valid?
            expect(validatable.errors[:postcode]).to eq(["Enter a postcode"])
          end
        end

        context "because the postcode is not correctly formated" do
          it "adds an appropriate validation error" do
            validatable.valid?
            expect(validatable.errors[:postcode]).to eq(["Enter a valid UK postcode"])
          end
        end

        context "because the postcode does not have associated adresses" do
          subject(:validatable) do
            Test::PostcodeValidatable.new(postcode_without_addresses)
          end

          before(:context) { VCR.insert_cassette("postcode_no_matches") }
          after(:context) { VCR.eject_cassette }

          it "adds an appropriate validation error" do
            no_results_error = "We cannot find any addresses for that postcode. " \
              "Check the postcode or enter the address manually."
            validatable.valid?
            expect(validatable.errors[:postcode]).to eq([no_results_error])
          end
        end
      end
    end
  end
end
