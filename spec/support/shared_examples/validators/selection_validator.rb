# frozen_string_literal: true

RSpec.shared_examples "a selection validator" do |validatable_class, property|
  it "includes CanValidateSelection" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }

    expect(included_modules)
      .to include(WasteExemptionsEngine::CanValidateSelection)
  end

  describe "#validate_each" do
    context "when the #{property} is not valid" do
      context "because the #{property} is not present" do
        validatable = validatable_class.new
        error_message = Helpers::Translator.error_message(validatable, property, :inclusion)

        it_behaves_like "an invalid record", validatable, property, error_message
      end

      context "because the #{property} is not from an approved list" do
        validatable = validatable_class.new("unexpected_#{property}")
        error_message = Helpers::Translator.error_message(validatable, property, :inclusion)

        it_behaves_like "an invalid record", validatable, property, error_message
      end
    end
  end
end
