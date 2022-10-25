# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Address Manual Forms", vcr: true do
    before { VCR.insert_cassette("postcode_valid") }
    after { VCR.eject_cassette }

    include_examples "GET form", :contact_address_manual_form, "/contact-address-manual"
    include_examples "POST form", :contact_address_manual_form, "/contact-address-manual" do
      let(:form_data) do
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

      let(:invalid_form_data) do
        [
          {
            contact_address: {
              premises: nil,
              street_address: nil,
              locality: nil,
              city: nil,
              postcode: nil
            }
          }
        ]
      end
    end
  end
end
