# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FrontOfficeEditDeclarationForm, type: :model do
    subject(:form) { build(:front_office_edit_declaration_form) }

    it "validates the declaration using the InclusionValidator class" do
      validators = form._validators
      expect(validators.keys).to include(:declaration)

      inclusion_validators = validators[:declaration].select do |v|
        v.instance_of?(ActiveModel::Validations::InclusionValidator)
      end
      expect(inclusion_validators.count).to eq(1)
      expect(inclusion_validators.first.options).to eq(in: [true])
    end

    it_behaves_like "a validated form", :front_office_edit_declaration_form do
      let(:valid_params) { { declaration: 1 } }
      let(:invalid_params) do
        [
          { declaration: 0 },
          { declaration: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the declaration agreement" do
          declaration = 1
          valid_params = { declaration: declaration }
          transient_registration = form.transient_registration

          expect(transient_registration.declaration).to be_blank
          form.submit(valid_params)
          expect(transient_registration.declaration).to be(true)
        end
      end
    end

    describe ".can_navigate_flexibly?" do
      it "returns false" do
        expect(described_class).not_to be_can_navigate_flexibly
      end
    end
  end
end
