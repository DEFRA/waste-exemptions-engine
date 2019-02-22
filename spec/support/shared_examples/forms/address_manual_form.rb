# frozen_string_literal: true

RSpec.shared_examples "a manual address form", vcr: true do |form_factory|
  it "includes AddressForm" do
    included_modules = described_class.ancestors.select { |ancestor| ancestor.instance_of?(Module) }
    expect(included_modules).to include(WasteExemptionsEngine::AddressForm)
  end

  it "is a type of AddressManualForm" do
    expect(described_class.ancestors).to include(WasteExemptionsEngine::AddressManualForm)
  end

  it "validates the address data using the ManualAddressValidator class" do
    validators = build(form_factory)._validators
    validator_classes = validators.values.flatten.map(&:class)
    expect(validator_classes).to include(WasteExemptionsEngine::ManualAddressValidator)
  end

  before(:each) { VCR.insert_cassette("postcode_valid") }
  after(:each) { VCR.eject_cassette }

  it_behaves_like "a validated form", form_factory do
    let(:valid_params) do
      [
        {
          token: form.token,
          premises: "Horizon House",
          street_address: "Deanery Rd",
          locality: "Bristol",
          city: "Bristol",
          postcode: "BS1 5AH"
        },
        {
          token: form.token,
          premises: "Horizon House",
          street_address: "Deanery Rd",
          locality: "",
          city: "Bristol",
          postcode: ""
        }
      ]
    end
    let(:invalid_params) do
      [
        {
          token: form.token,
          premises: "",
          street_address: "",
          locality: "",
          city: "",
          postcode: ""
        },
        {
          token: form.token,
          premises: Helpers::TextGenerator.random_string(201), # The max length is 200.
          street_address: Helpers::TextGenerator.random_string(161), # The max length is 160.
          locality: Helpers::TextGenerator.random_string(71), # The max length is 70.
          city: Helpers::TextGenerator.random_string(31), # The max length is 30.
          postcode: Helpers::TextGenerator.random_string(9), # The max length is 8.
        }
      ]
    end
  end

  # Make sure the transient registration gets updated when submitted.
  describe "#submit" do
    context "when the form is valid" do
      subject(:form) { build(form_factory) }
      let(:address_data) do
        {
          premises: "Example House",
          street_address: "2 On The Road",
          locality: "Near Horizon House",
          city: "Bristol",
          postcode: "BS1 5AH"
        }
      end
      let(:white_space_address_data) { address_data.each_with_object({}) { |(k, v), h| h[k] = "  #{v}  " } }
      let(:valid_params) { address_data.merge(token: form.token) }
      let(:white_space_params) { white_space_address_data.merge(token: form.token) }
      let(:transient_registration) { form.transient_registration }

      it "updates the transient registration with the submitted address data" do
        # Ensure the test data is properly configured:
        expect(transient_registration.transient_addresses).to be_empty

        form.submit(valid_params)

        expect(transient_registration.transient_addresses.count).to eq(1)
        submitted_address = transient_registration.transient_addresses.first
        address_data.each do |key, value|
          expect(submitted_address.send(key)).to eq(value)
        end
      end

      context "when the address data includes extraneous white space" do
        it "strips the extraneous white space from the submitted address data" do
          # Ensure the test data is properly configured:
          address_data.each do |key, value|
            expect(white_space_params[key]).not_to eq(value)
            expect(white_space_params[key].strip).to eq(value)
          end
          expect(transient_registration.transient_addresses).to be_empty

          form.submit(white_space_params)

          expect(transient_registration.transient_addresses.count).to eq(1)
          submitted_address = transient_registration.transient_addresses.first
          address_data.each do |key, value|
            expect(submitted_address.send(key)).to eq(value)
          end
        end
      end
    end
  end
end
