# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CertificatePresenter do
    subject { described_class.new(registration) }

    describe "#partnership?" do
      let(:registration) { double(:registration, business_type: business_type) }

      context "when the business type is partnership" do
        let(:business_type) { "partnership" }

        it "returns true" do
          expect(subject).to be_partnership
        end
      end

      context "when the business type is not partnership" do
        let(:business_type) { "something_else" }

        it "returns false" do
          expect(subject).to_not be_partnership
        end
      end
    end

    describe "#partners_names" do
      let(:partners) do
        [
          double(:person, first_name: "Joe", last_name: "Snow", partner?: true),
          double(:person, first_name: "Anita", last_name: "Flieg", partner?: true)
        ]
      end
      let(:registration) { double(:registration, people: partners) }

      it "returns an html formatted string of partners names" do
        expect(subject.partners_names).to eq("Joe Snow</br>Anita Flieg")
      end
    end
  end
end
