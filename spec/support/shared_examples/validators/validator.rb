# frozen_string_literal: true

RSpec.shared_examples "a validator" do |validatable_class, property, valid_input|
  it "is a type of BaseValidator" do
    expect(described_class.ancestors)
      .to include(WasteExemptionsEngine::BaseValidator)
  end

  describe "#validate_each" do
    context "when the #{property} is valid" do
      valid_input = [valid_input] unless valid_input.is_a? Array
      it_behaves_like "a valid record", validatable_class.new(*valid_input)
    end
  end
end
