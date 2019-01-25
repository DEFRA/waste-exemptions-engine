# frozen_string_literal: true

RSpec.shared_examples "Registration scopes" do
  let(:matching_registration) { create(:registration) }
  let(:non_matching_registration) { create(:registration) }

  describe "#search_term" do
    let(:term) { nil }
    let(:scope) { WasteExemptionsEngine::Registration.search_term(term) }

    it "returns nothing when no search term is given" do
      expect(scope.length).to eq(0)
    end

    context "when the search term is a reference" do
      let(:term) { matching_registration.reference }

      it "returns renewals with a matching reference" do
        expect(scope).to include(matching_registration)
      end

      it "does not return others" do
        expect(scope).not_to include(non_matching_registration)
      end
    end
  end
end
