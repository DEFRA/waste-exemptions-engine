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

    describe "#validate" do
      context "when the business type is partnership" do
        let(:transient_registration) { create(:transient_registration, :partnership) }
        let(:error_message) do
          Helpers::Translator.state_error_message(validatable, :not_enough_main_people, :other, count: 2)
        end

        subject(:validatable) { Test::MainPersonValidatable.new(transient_registration) }

        context "and the number of people is two" do
          before(:each) do
            transient_registration.transient_people = [build(:transient_person), build(:transient_person)]
          end

          it "confirms the object is valid" do
            expect(validatable).to be_valid
          end

          it "the errors are empty" do
            validatable.valid?
            expect(validatable.errors).to be_empty
          end
        end

        context "and the number of people is one" do
          before(:each) { transient_registration.transient_people = [build(:transient_person)] }

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

        context "and there aren't any people" do
          before(:each) { transient_registration.transient_people = [] }

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

      context "when the business type is sole_trader" do
        let(:transient_registration) { create(:transient_registration, :sole_trader) }
        subject(:validatable) { Test::MainPersonValidatable.new(transient_registration) }

        context "and the number of people is one" do
          before(:each) { transient_registration.transient_people = [build(:transient_person)] }

          it "confirms the object is valid" do
            expect(validatable).to be_valid
          end

          it "the errors are empty" do
            validatable.valid?
            expect(validatable.errors).to be_empty
          end
        end

        context "and the number of people is two" do
          let(:error_message) do
            Helpers::Translator.state_error_message(validatable, :too_many_main_people, :one)
          end

          before(:each) do
            transient_registration.transient_people = [build(:transient_person), build(:transient_person)]
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

        context "and there aren't any people" do
          let(:error_message) do
            Helpers::Translator.state_error_message(validatable, :not_enough_main_people, :one)
          end

          before(:each) { transient_registration.transient_people = [] }

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

      %i[limited_company limited_liability_partnership local_authority charity].each do |business_type|
        context "when the business type is #{business_type}" do
          let(:transient_registration) { create(:transient_registration, business_type) }
          subject(:validatable) { Test::MainPersonValidatable.new(transient_registration) }

          context "and the number of people is two" do
            before(:each) do
              transient_registration.transient_people = [build(:transient_person), build(:transient_person)]
            end

            it "confirms the object is valid" do
              expect(validatable).to be_valid
            end

            it "the errors are empty" do
              validatable.valid?
              expect(validatable.errors).to be_empty
            end
          end

          context "and the number of people is one" do
            before(:each) { transient_registration.transient_people = [build(:transient_person)] }

            it "confirms the object is valid" do
              expect(validatable).to be_valid
            end

            it "the errors are empty" do
              validatable.valid?
              expect(validatable.errors).to be_empty
            end
          end

          context "and there aren't any people" do
            let(:error_message) do
              Helpers::Translator.state_error_message(validatable, :not_enough_main_people, :one)
            end

            before(:each) { transient_registration.transient_people = [] }

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
