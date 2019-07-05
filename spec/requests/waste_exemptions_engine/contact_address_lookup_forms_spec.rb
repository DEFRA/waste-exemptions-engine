# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Address Lookup Forms", type: :request, vcr: true do
    before(:each) { VCR.insert_cassette("postcode_valid", allow_playback_repeats: true) }
    after(:each) { VCR.eject_cassette }

    include_examples "GET form", :contact_address_lookup_form, "/contact-address-lookup"
    include_examples "go back", :contact_address_lookup_form, "/contact-address-lookup/back"
    include_examples "POST form", :contact_address_lookup_form, "/contact-address-lookup" do
      let(:form_data) { { temp_address: "340116" } }
      let(:invalid_form_data) { [{ temp_address: nil }] }
    end

    include_examples "skip to manual address",
                     :contact_address_lookup_form,
                     request_path: "/contact-address-lookup/skip_to_manual_address",
                     result_path: "/contact-address-manual"
  end
end
