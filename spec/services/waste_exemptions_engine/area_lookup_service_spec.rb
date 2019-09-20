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
      before(:each) do
        allow(DefraRuby::Area::PublicFaceAreaService)
          .to receive(:run)
          .and_return(response)
      end

      context "when the lookup is successful" do
        let(:easting) { 358_205.03 }
        let(:northing) { 172_708.07 }
        let(:response) do
          area = Test::Area::Area.new(
            "WSX",
            "Wessex",
            "Wessex"
          )
          Test::Area::Response.new([area], true)
        end

        it "returns the matching area" do
          expect(described_class.run(easting, northing)).to eq("Wessex")
        end
      end

      context "when the lookup is unsuccessful" do
        context "because no match was found" do
          let(:easting) { 194_868 }
          let(:northing) { 215_313 }
          let(:response) { Test::Area::Response.new([], false, DefraRuby::Area::NoMatchError.new) }

          it "returns null" do
            expect(described_class.run(easting, northing)).to be_nil
          end
        end

        context "because it failed" do
          let(:easting) { 194_868 }
          let(:northing) { 215_313 }
          let(:response) { Test::Area::Response.new([], false, StandardError.new) }

          it "returns null" do
            expect(described_class.run(easting, northing)).to be_nil
          end
        end
      end
    end
  end
end
