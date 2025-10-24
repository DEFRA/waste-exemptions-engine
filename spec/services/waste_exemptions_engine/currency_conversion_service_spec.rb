# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CurrencyConversionService do
    describe ".convert_pence_to_pounds" do
      let(:helper) { ActionController::Base.helpers }

      before { allow(helper).to receive(:number_to_currency) }

      context "when hide_pence_if_zero is false" do
        it "calls number_to_currency with precision 2" do
          described_class.convert_pence_to_pounds(100, hide_pence_if_zero: false)

          expect(helper).to have_received(:number_to_currency).with(1.0, unit: "", precision: 2)
        end
      end

      context "when hide_pence_if_zero is true" do
        it "calls number_to_currency with precision 0 for whole pounds" do
          described_class.convert_pence_to_pounds(100, hide_pence_if_zero: true)

          expect(helper).to have_received(:number_to_currency).with(1.0, unit: "", precision: 0)
        end

        it "calls number_to_currency with precision 2 for non-whole pounds" do
          described_class.convert_pence_to_pounds(150, hide_pence_if_zero: true)

          expect(helper).to have_received(:number_to_currency).with(1.5, unit: "", precision: 2)
        end
      end

      describe "integration tests" do
        it "formats whole pounds with hide_pence_if_zero as true" do
          expect(described_class.convert_pence_to_pounds(100, hide_pence_if_zero: true)).to eq("1")
        end

        it "formats whole pounds with hide_pence_if_zero as false" do
          expect(described_class.convert_pence_to_pounds(100, hide_pence_if_zero: false)).to eq("1.00")
        end

        it "formats non-whole pounds with decimals" do
          expect(described_class.convert_pence_to_pounds(7650, hide_pence_if_zero: true)).to eq("76.50")
        end

        it "includes thousand separators for large amounts" do
          expect(described_class.convert_pence_to_pounds(123_456, hide_pence_if_zero: false)).to eq("1,234.56")
        end
      end
    end
  end
end
