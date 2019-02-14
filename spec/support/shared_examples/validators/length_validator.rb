# frozen_string_literal: true

RSpec.shared_examples "a length validator" do |validatable_class, property, invalid_input|
  it "includes CanValidateLength" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

    expect(included_modules)
      .to include(WasteExemptionsEngine::CanValidateLength)
  end

  describe "#validate_each" do
    context "when the #{property} is not valid" do
      context "because the #{property} is too long" do
        invalid_input = [invalid_input] unless invalid_input.is_a? Array
        validatable = validatable_class.new(*invalid_input)
        error_message = Helpers::Translator.error_message(validatable, property, :too_long)

        it_behaves_like "an invalid record", validatable, property, error_message
      end
    end
  end
end
