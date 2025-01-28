# frozen_string_literal: true

require "rails_helper"

class SortableTest
  include WasteExemptionsEngine::CanSortExemptions
end

module WasteExemptionsEngine
  RSpec.describe "CanSortExemptions" do

    subject(:sortable) { SortableTest.new }

    # rubocop:disable RSpec/IndexedLet
    let(:exemption_S8) { build(:exemption, code: "S8") }
    let(:exemption_U11) { build(:exemption, code: "U11") }
    let(:exemption_D1) { build(:exemption, code: "D1") }
    let(:exemption_T21) { build(:exemption, code: "T21") }
    let(:exemption_U2) { build(:exemption, code: "U2") }
    let(:exemption_U15) { build(:exemption, code: "U15") }
    let(:exemption_T5) { build(:exemption, code: "T5") }
    let(:exemption_S1) { build(:exemption, code: "S1") }
    let(:exemption_D7) { build(:exemption, code: "D7") }
    # rubocop:enable RSpec/IndexedLet

    let(:exemptions) do
      [
        exemption_S8,
        exemption_U11,
        exemption_D1,
        exemption_T21,
        exemption_U2,
        exemption_U15,
        exemption_T5,
        exemption_S1,
        exemption_D7
      ]
    end

    describe "#sorted_exemption_codes" do
      it "sorts exemption codes correctly" do
        expect(sortable.sorted_exemption_codes(exemptions)).to eq(%w[U2 U11 U15 T5 T21 D1 D7 S1 S8])
      end
    end

    describe "#sorted_exemptions" do
      it "sorts exemptions correctly" do
        expect(sortable.sorted_exemptions(exemptions)).to eq(
          [
            exemption_U2,
            exemption_U11,
            exemption_U15,
            exemption_T5,
            exemption_T21,
            exemption_D1,
            exemption_D7,
            exemption_S1,
            exemption_S8
          ]
        )
      end
    end
  end
end
