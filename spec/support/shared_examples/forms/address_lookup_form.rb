# frozen_string_literal: true

RSpec.shared_examples "an address lookup form", vcr: true do
  it "includes CanCreateAddressFromFinderData" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }
    expect(included_modules).to include(WasteExemptionsEngine::CanCreateAddressFromFinderData)
  end

  it "is a type of AddressLookupFormBase" do
    expect(described_class.ancestors).to include(WasteExemptionsEngine::AddressLookupFormBase)
  end
end
