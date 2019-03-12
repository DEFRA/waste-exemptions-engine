# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Site Address Manual Forms", type: :request, vcr: true do
    before(:each) { VCR.insert_cassette("postcode_valid") }
    after(:each) { VCR.eject_cassette }

    include_examples "GET form", :site_address_manual_form, "/site-address-manual"
    include_examples "go back", :site_address_manual_form, "/site-address-manual/back"
    include_examples "POST form", :site_address_manual_form, "/site-address-manual" do
      let(:form_data) do
        {
          premises: "Example House",
          street_address: "2 On The Road",
          locality: "Near Horizon House",
          city: "Bristol",
          postcode: "BS1 5AH"
        }
      end
    end
  end
end
