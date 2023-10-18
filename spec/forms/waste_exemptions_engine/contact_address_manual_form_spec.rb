# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ContactAddressManualForm, type: :model do
    let(:form_factory) { :contact_address_manual_form }

    after { VCR.eject_cassette }
    before { VCR.insert_cassette("postcode_valid") }

    it "validates the address data using the ManualAddressValidator class" do
      validators = build(form_factory)._validators
      validator_classes = validators.values.flatten.map(&:class)
      expect(validator_classes).to include(WasteExemptionsEngine::ManualAddressValidator)
    end

    it_behaves_like "a validated form", :contact_address_manual_form do
      let(:valid_params) do
        [
          {
            contact_address: {
              premises: "Horizon House",
              street_address: "Deanery Rd",
              locality: "Bristol",
              city: "Bristol",
              postcode: "BS1 5AH"
            }
          },
          {
            contact_address: {
              premises: "Horizon House",
              street_address: "Deanery Rd",
              locality: "",
              city: "Bristol",
              postcode: ""
            }
          }
        ]
      end
      let(:invalid_params) do
        [
          {
            contact_address: {
              premises: "",
              street_address: "",
              locality: "",
              city: "",
              postcode: ""
            }
          },
          {
            contact_address: {
              premises: Helpers::TextGenerator.random_string(201), # The max length is 200.
              street_address: Helpers::TextGenerator.random_string(161), # The max length is 160.
              locality: Helpers::TextGenerator.random_string(71), # The max length is 70.
              city: Helpers::TextGenerator.random_string(31), # The max length is 30.
              postcode: Helpers::TextGenerator.random_string(9) # The max length is 8.
            }
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
            contact_address: {
              premises: "Example House",
              street_address: "2 On The Road",
              locality: "Near Horizon House",
              city: "Bristol",
              postcode: "BS1 5AH"
            }
          }
        end
        let(:valid_params) { address_data }
        let(:transient_registration) { form.transient_registration }

        it "updates the transient registration with the submitted address data" do
          aggregate_failures do
            # Ensure the test data is properly configured:
            expect(transient_registration.transient_addresses).to be_empty

            form.submit(ActionController::Parameters.new(valid_params).permit!)

            expect(transient_registration.transient_addresses.count).to eq(1)
            submitted_address = transient_registration.transient_addresses.first
            address_data[:contact_address].each do |key, value|
              expect(submitted_address.send(key)).to eq(value)
            end
          end
        end

        context "when the address data includes extraneous white space" do
          let(:white_space_address_data) do
            {
              contact_address: {
                premises: "  Example House ",
                street_address: " 2 On The Road  ",
                locality: " Near Horizon House   ",
                city: "  Bristol  ",
                postcode: "   BS1 5AH  "
              }
            }
          end
          let(:white_space_params) { white_space_address_data }

          it "strips the extraneous white space from the submitted address data" do
            aggregate_failures do
              # Ensure the test data is properly configured:
              address_data[:contact_address].each do |key, value|
                expect(white_space_params[:contact_address][key]).not_to eq(value)
                expect(white_space_params[:contact_address][key].strip).to eq(value)
              end
              expect(transient_registration.transient_addresses).to be_empty

              form.submit(ActionController::Parameters.new(white_space_params).permit!)

              expect(transient_registration.reload.transient_addresses.count).to eq(1)
              submitted_address = transient_registration.transient_addresses.first
              address_data[:contact_address].each do |key, value|
                expect(submitted_address.send(key)).to eq(value)
              end
            end
          end
        end
      end
    end
  end
end
