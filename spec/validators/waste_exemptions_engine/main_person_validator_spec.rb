# frozen_string_literal: true

require "rails_helper"

module Test
  MainPersonValidatable = Struct.new(:transient_registration) do
    include ActiveModel::Validations
    include WasteExemptionsEngine::CanLimitNumberOfMainPeople

    attr_accessor :business_type

    # @transient_registration is called directly in CanLimitNumberOfMainPeople so needs to be set.
    def initialize(*args)
      super(*args)
      @transient_registration = args[0]
      @business_type = @transient_registration.business_type
    end

    def fields_have_content?
      false
    end

    validates_with WasteExemptionsEngine::MainPersonValidator
  end
end

module WasteExemptionsEngine
  RSpec.describe MainPersonValidator, type: :model do
    it "is a type of PersonValidator" do
      expect(described_class.ancestors).to include(WasteExemptionsEngine::PersonValidator)
    end

    expectations = [
      { business_type: :partnership,                   num_people: { 0 => false, 1 => false, 2 => true } },
      { business_type: :sole_trader,                   num_people: { 0 => false, 1 => true,  2 => false } },
      { business_type: :limited_company,               num_people: { 0 => false, 1 => true,  2 => true } },
      { business_type: :limited_liability_partnership, num_people: { 0 => false, 1 => true,  2 => true } },
      { business_type: :local_authority,               num_people: { 0 => false, 1 => true,  2 => true } },
      { business_type: :charity,                       num_people: { 0 => false, 1 => true,  2 => true } }
    ]

    describe "#validate" do
      expectations.each do |expectation|
        business_type = expectation[:business_type]
        allowed_num_people = expectation[:num_people]

        context "when the business type is #{business_type}" do
          let(:transient_registration) { create(:transient_registration, business_type) }
          subject(:validatable) { Test::MainPersonValidatable.new(transient_registration) }

          min_people = allowed_num_people.rassoc(true).first # This will get the first key that has a value of true.

          allowed_num_people.each do |num_people, is_allowed|

            context "and the number of people is #{num_people}" do
              before(:each) do
                people = []
                num_people.times { people << build(:transient_person) }
                transient_registration.transient_people = people
              end

              if is_allowed
                it "confirms the object is valid" do
                  expect(validatable).to be_valid
                end

                it "the errors are empty" do
                  validatable.valid?
                  expect(validatable.errors).to be_empty
                end
              else
                let(:error_message) do
                  Helpers::Translator.main_person_error_message(validatable, num_people, min_people)
                end

                it "confirms the object is invalid" do
                  expect(validatable).to_not be_valid
                end

                it "adds a single validation error to the record" do
                  validatable.valid?
                  expect(validatable.errors[:base].count).to eq(1)
                end

                it "adds an appropriate validation error" do
                  validatable.valid?
                  expect(error_message).to_not include("translation missing:")
                  expect(validatable.errors[:base]).to eq([error_message])
                end
              end
            end
          end
        end
      end
    end
  end
end
