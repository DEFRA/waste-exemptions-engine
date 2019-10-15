# frozen_string_literal: true

RSpec.shared_examples "an address lookup form", vcr: true do
  it "is a type of AddressLookupFormBase" do
    expect(described_class.ancestors).to include(WasteExemptionsEngine::AddressLookupFormBase)
  end
end
