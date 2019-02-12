# frozen_string_literal: true

RSpec.shared_examples "a presence validator" do |validatable_class, property|
  # it "includes ValidatesPresence" do
  #   expect(described_class.includes)
  #     .to include(WasteExemptionsEngine::ValidatesPresence)
  # end

  describe "#validate_each" do
    context "when the #{property} is not valid" do
      context "because the #{property} is not present" do
        subject(:validatable) { validatable_class.new }

        it "confirms the object is invalid" do
          expect(validatable).to_not be_valid
        end

        it "adds a single validation error to the record" do
          validatable.valid?
          expect(validatable.errors[property].count).to eq(1)
        end

        it "adds an appropriate validation error" do
          error_msg = Helpers::Translator.error_message(validatable, property, :blank)
          validatable.valid?
          expect(validatable.errors[property]).to eq([error_msg])
        end
      end
    end
  end
end
