# frozen_string_literal: true

require "rails_helper"

module Test
  module Area
    Response = Struct.new(:areas, :successful, :error) do
      def successful?
        successful
      end
    end

    Area = Struct.new(:code, :long_name, :short_name)
  end
end

module WasteExemptionsEngine
  RSpec.describe AreaLookupService do
    describe ".run" do

      context "when the lookup is successful" do
        before(:each) do
          allow(DefraRuby::Area::PublicFaceAreaService)
            .to receive(:run)
            .and_return(response)
        end

        let(:coordinates) { { easting: 358_205.03, northing: 172_708.07 } }
        let(:response) do
          area = Test::Area::Area.new(
            "WSX",
            "Wessex",
            "Wessex"
          )
          Test::Area::Response.new([area], true)
        end

        it "returns the matching area" do
          expect(described_class.run(coordinates)).to eq("Wessex")
        end
      end

      context "when the lookup is unsuccessful" do
        before(:each) do
          allow(DefraRuby::Area::PublicFaceAreaService)
            .to receive(:run)
            .and_return(response)
        end

        let(:coordinates) { { easting: 194_868, northing: 215_313 } }

        context "because no match was found" do
          let(:response) { Test::Area::Response.new([], false, DefraRuby::Area::NoMatchError.new) }

          it "returns null" do
            expect(described_class.run(coordinates)).to be_nil
          end
        end

        context "because it failed" do
          let(:response) { Test::Area::Response.new([], false, StandardError.new) }

          it "returns null" do
            expect(described_class.run(coordinates)).to be_nil
          end
        end
      end

      context "when passed invalid arguments" do
        context "for example nil" do
          let(:coordinates) { { easting: nil, northing: 215_313 } }

          it "returns null" do
            expect(described_class.run(coordinates)).to be_nil
          end
        end

        context "for example not a numeric value" do
          let(:coordinates) { { easting: "not_a_number", northing: 215_313 } }

          it "returns null" do
            expect(described_class.run(coordinates)).to be_nil
          end
        end
      end
    end
  end
end
