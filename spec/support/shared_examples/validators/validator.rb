# frozen_string_literal: true

RSpec.shared_examples "a validator" do |validator, validatable_class, valid_value|
  it "is a type of BaseValidator" do
    expect(described_class.ancestors)
      .to include(WasteExemptionsEngine::BaseValidator)
  end

  describe "#validate_each" do
    context "when the postcode is valid" do
      subject(:validatable) { validatable_class.new(valid_value) }

      it "gets called" do
        expect_any_instance_of(validator)
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
  end
end
