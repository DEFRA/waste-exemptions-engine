# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CertificatePresenter do
    subject { described_class.new(registration) }

    describe "#partnership?" do
      context "when the business type is partnership" do
        let(:registration) { build(:registration, :partnership) }

        it "returns true" do
          expect(subject).to be_partnership
        end
      end

      context "when the business type is not partnership" do
        let(:registration) { build(:registration, :limited_company) }

        it "returns false" do
          expect(subject).to_not be_partnership
        end
      end
    end

    describe "#partners_names" do
      let(:registration) { build(:registration, :partnership) }

      it "returns an html formatted string of partners names" do
        result = registration.people.map do |partner|
          "#{partner.first_name} #{partner.last_name}"
        end.join("</br>")

        expect(subject.partners_names).to eq(result)
      end
    end
  end
end
