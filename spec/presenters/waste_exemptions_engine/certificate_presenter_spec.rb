# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CertificatePresenter do
    subject(:presenter) { described_class.new(registration) }

    describe "#partners_names" do
      let(:registration) { build(:registration, :partnership) }

      it "returns an html formatted string of partners names" do
        result = registration.people.map do |partner|
          "#{partner.first_name} #{partner.last_name}"
        end.join("</br>")

        expect(presenter.partners_names).to eq(result)
      end
    end
  end
end
