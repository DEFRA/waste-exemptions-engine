# frozen_string_literal: true

require "rails_helper"

module Test
  RegistrationLookupValidatable = Struct.new(:registration) do
    include ActiveModel::Validations

    attr_reader :reference
    attr_reader :active_exemptions

    validates_with WasteExemptionsEngine::RegistrationLookupValidator, attributes: [:reference]
  end
end

module WasteExemptionsEngine
  RSpec.describe RegistrationLookupValidator do

    subject(:validator) { Test::RegistrationLookupValidatable.new }

    let(:inactive_registration) { create(:registration) }
    let(:active_registration) { create(:registration, :with_active_exemptions) }

    before do
      allow(validator).to receive(:reference).and_return(reference)
    end

    shared_examples "is valid" do
      it "passes the validity check" do
        expect(validator).to be_valid
      end
    end

    shared_examples "is not valid" do
      it "does not pass the validity check" do
        expect(validator).not_to be_valid
      end
    end

    context "with invalid reference" do
      let(:reference) { nil }

      it_behaves_like "is not valid"
    end

    context "with a valid reference, but inactive registration" do
      let(:reference) { inactive_registration.reference }

      it_behaves_like "is not valid"
    end

    context "with a valid reference and active registration" do
      let(:reference) { active_registration.reference }

      it_behaves_like "is valid"
    end
  end
end
