# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe DeclarationForm, type: :model do
    subject(:form) { build(:declaration_form) }

    it "validates the phone number using the DeclarationForm class" do
      validators = form._validators
      expect(validators.keys).to include(:declaration)

      inclusion_validators = validators[:declaration].select do |v|
        v.class == ActiveModel::Validations::InclusionValidator
      end
      expect(inclusion_validators.count).to eq(1)
      expect(inclusion_validators.first.options).to eq(in: [1])
    end

    it_behaves_like "a validated form", :declaration_form do
      let(:valid_params) { { token: form.token, declaration: 1 } }
      let(:invalid_params) do
        [
          { token: form.token, declaration: 0 },
          { token: form.token, declaration: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the declaration agreement" do
          declaration = 1
          valid_params = { token: form.token, declaration: declaration }
          transient_registration = form.transient_registration

          expect(transient_registration.declaration).to be_blank
          form.submit(valid_params)
          expect(transient_registration.declaration).to eq(true)
        end
      end
    end
  end
end
