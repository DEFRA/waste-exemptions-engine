# frozen_string_literal: true

require "spec_helper"

RSpec.shared_examples_for "can_sort_exemption_codes" do |presenter_class|
  let(:exemptions) do
    [
      WasteExemptionsEngine::Exemption.find_or_create_by(code: "S8"),
      WasteExemptionsEngine::Exemption.find_or_create_by(code: "U11"),
      WasteExemptionsEngine::Exemption.find_or_create_by(code: "D1"),
      WasteExemptionsEngine::Exemption.find_or_create_by(code: "T21"),
      WasteExemptionsEngine::Exemption.find_or_create_by(code: "U2"),
      WasteExemptionsEngine::Exemption.find_or_create_by(code: "U15"),
      WasteExemptionsEngine::Exemption.find_or_create_by(code: "T5"),
      WasteExemptionsEngine::Exemption.find_or_create_by(code: "S1"),
      WasteExemptionsEngine::Exemption.find_or_create_by(code: "D7")
    ]
  end
  let(:registration) { create(:registration, exemptions: exemptions) }
  let(:presenter) { presenter_class.new(registration) }

  it "has a sorted_exemption_codes method available" do
    expect(presenter).to respond_to(:sorted_exemption_codes)
  end

  it "has exemption codes sorted correctly" do
    expect(presenter.sorted_exemption_codes).to eq(%w[U2 U11 U15 T5 T21 D1 D7 S1 S8])
  end
end
