# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Site Address Manual Forms", type: :request, vcr: true do
    before(:each) { VCR.insert_cassette("postcode_valid") }
    after(:each) { VCR.eject_cassette }

    include_examples "GET form", :site_address_manual_form, "/site-address-manual"
    include_examples "POST form", :site_address_manual_form, "/site-address-manual" do
      let(:form_data) do
        {
          site_address: {
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
            site_address: {
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
