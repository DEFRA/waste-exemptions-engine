# frozen_string_literal: true

RSpec.shared_examples "an address lookup form", vcr: true do |form_factory|
  it "includes CanAddOrReplaceAnAddress" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }
    expect(included_modules).to include(WasteExemptionsEngine::CanAddOrReplaceAnAddress)
  end

  it "is a type of AddressLookupForm" do
    expect(described_class.ancestors).to include(WasteExemptionsEngine::AddressLookupForm)
  end

  it "validates the temp_address using the AddressValidator class" do
    validators = build(form_factory)._validators
    expect(validators.keys).to include(:temp_address)
    expect(validators[:temp_address].first.class)
      .to eq(WasteExemptionsEngine::AddressValidator)
  end

  before(:each) { VCR.insert_cassette("postcode_valid") }
  after(:each) { VCR.eject_cassette }

  it_behaves_like "a validated form", form_factory do
    let(:valid_params) { { token: form.token, temp_address: "340116" } }
    let(:invalid_params) do
      [
        { token: form.token, temp_address: "foo" },
        { token: form.token, temp_address: "" }
      ]
    end
  end

  describe "#submit" do
    context "when the form is valid" do
      it "updates the transient registration with the selected address" do
        form = build(form_factory)
        address_uprn = %w[340116 340117].sample
        valid_params = { token: form.token, temp_address: address_uprn }
        transient_registration = form.transient_registration

        expect(transient_registration.transient_addresses).to be_empty
        form.submit(valid_params)
        expect(transient_registration.transient_addresses.count).to eq(1)
        expect(transient_registration.transient_addresses.first.uprn).to eq(address_uprn)
      end
    end
  end
end
