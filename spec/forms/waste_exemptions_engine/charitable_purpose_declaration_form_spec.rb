# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CharitablePurposeDeclarationForm, type: :model do
    subject(:form) { build(:charitable_purpose_declaration_form) }

    it "validates the charitable_purpose_declaration using the InclusionValidator class" do
      validators = form._validators

      inclusion_validators = validators[:charitable_purpose_declaration].select do |v|
        v.instance_of?(ActiveModel::Validations::InclusionValidator)
      end
      aggregate_failures do
        expect(inclusion_validators.count).to eq(1)
        expect(inclusion_validators.first.options).to eq(in: [true])
      end
    end

    it_behaves_like "a validated form", :charitable_purpose_declaration_form do
      let(:valid_params) { { charitable_purpose_declaration: 1 } }
      let(:invalid_params) do
        [
          { charitable_purpose_declaration: 0 },
          { charitable_purpose_declaration: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the declaration agreement" do
          valid_params = { charitable_purpose_declaration: 1 }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.charitable_purpose_declaration).to be_blank
            form.submit(valid_params)
            expect(transient_registration.charitable_purpose_declaration).to be(true)
          end
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
