# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CurrencyConversionService do
    describe ".convert_pence_to_pounds" do
      context "with hide_pence_if_zero: false" do
        it "formats whole pounds with two decimal places" do
          expect(described_class.convert_pence_to_pounds(100, hide_pence_if_zero: false)).to eq("1.00")
        end

        it "formats 10 pence as 0.10" do
          expect(described_class.convert_pence_to_pounds(10, hide_pence_if_zero: false)).to eq("0.10")
        end

        it "formats 39 pence as 0.39" do
          expect(described_class.convert_pence_to_pounds(39, hide_pence_if_zero: false)).to eq("0.39")
        end

        it "formats 7650 pence as 76.50" do
          expect(described_class.convert_pence_to_pounds(7650, hide_pence_if_zero: false)).to eq("76.50")
        end

        it "formats 100,000 pence as 1,000.00" do
          expect(described_class.convert_pence_to_pounds(100_000, hide_pence_if_zero: false)).to eq("1,000.00")
        end

        it "formats 123,456 pence as 1,234.56" do
          expect(described_class.convert_pence_to_pounds(123_456, hide_pence_if_zero: false)).to eq("1,234.56")
        end

        it "formats amounts over 10,000 with thousand separators" do
          expect(described_class.convert_pence_to_pounds(1_000_000, hide_pence_if_zero: false)).to eq("10,000.00")
        end

        it "formats amounts over 100,000 with thousand separators" do
          expect(described_class.convert_pence_to_pounds(10_000_000, hide_pence_if_zero: false)).to eq("100,000.00")
        end
      end

      context "with hide_pence_if_zero: true" do
        it "formats 100 pence as 1 without decimal" do
          expect(described_class.convert_pence_to_pounds(100, hide_pence_if_zero: true)).to eq("1")
        end

        it "formats 1000 pence as 10 without decimal" do
          expect(described_class.convert_pence_to_pounds(1000, hide_pence_if_zero: true)).to eq("10")
        end

        it "formats 7600 pence as 76 without decimal" do
          expect(described_class.convert_pence_to_pounds(7600, hide_pence_if_zero: true)).to eq("76")
        end

        it "formats 10 pence as 0.10 with decimal" do
          expect(described_class.convert_pence_to_pounds(10, hide_pence_if_zero: true)).to eq("0.10")
        end

        it "formats 39 pence as 0.39 with decimal" do
          expect(described_class.convert_pence_to_pounds(39, hide_pence_if_zero: true)).to eq("0.39")
        end

        it "formats 7650 pence as 76.50 with decimal" do
          expect(described_class.convert_pence_to_pounds(7650, hide_pence_if_zero: true)).to eq("76.50")
        end

        it "formats whole pounds over 1,000 with thousand separators and no decimal" do
          expect(described_class.convert_pence_to_pounds(100_000, hide_pence_if_zero: true)).to eq("1,000")
        end

        it "formats whole pounds over 10,000 with thousand separators and no decimal" do
          expect(described_class.convert_pence_to_pounds(1_000_000, hide_pence_if_zero: true)).to eq("10,000")
        end

        it "formats whole pounds over 100,000 with thousand separators and no decimal" do
          expect(described_class.convert_pence_to_pounds(10_000_000, hide_pence_if_zero: true)).to eq("100,000")
        end

        it "formats amounts over 1,000 with pence showing thousand separators and decimals" do
          expect(described_class.convert_pence_to_pounds(123_456, hide_pence_if_zero: true)).to eq("1,234.56")
        end

        it "formats zero as 0" do
          expect(described_class.convert_pence_to_pounds(0, hide_pence_if_zero: true)).to eq("0")
        end
      end
    end

    describe ".convert_pounds_to_pence" do
      it "converts 1 pound to 100 pence" do
        expect(described_class.convert_pounds_to_pence(1)).to eq(100)
      end

      it "converts 10 pounds to 1000 pence" do
        expect(described_class.convert_pounds_to_pence(10)).to eq(1000)
      end

      it "converts 100 pounds to 10,000 pence" do
        expect(described_class.convert_pounds_to_pence(100)).to eq(10_000)
      end

      it "converts 1.50 pounds to 150 pence" do
        expect(described_class.convert_pounds_to_pence(1.50)).to eq(150)
      end

      it "converts 76.50 pounds to 7650 pence" do
        expect(described_class.convert_pounds_to_pence(76.50)).to eq(7650)
      end

      it "converts 0.10 pounds to 10 pence" do
        expect(described_class.convert_pounds_to_pence(0.10)).to eq(10)
      end

      it "rounds 1.234 pounds down to 123 pence" do
        expect(described_class.convert_pounds_to_pence(1.234)).to eq(123)
      end

      it "rounds 1.235 pounds up to 124 pence" do
        expect(described_class.convert_pounds_to_pence(1.235)).to eq(124)
      end

      it "handles string input '1.50'" do
        expect(described_class.convert_pounds_to_pence("1.50")).to eq(150)
      end

      it "handles string input '76'" do
        expect(described_class.convert_pounds_to_pence("76")).to eq(7600)
      end

      it "handles zero" do
        expect(described_class.convert_pounds_to_pence(0)).to eq(0)
      end
    end
  end
end
