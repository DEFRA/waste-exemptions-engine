# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Operator Address Lookup Forms", type: :request, vcr: true do
    before(:each) { VCR.insert_cassette("postcode_valid", allow_playback_repeats: true) }
    after(:each) { VCR.eject_cassette }

    include_examples "GET form", :operator_address_lookup_form, "/operator-address-lookup"
    include_examples "go back", :operator_address_lookup_form, "/operator-address-lookup/back"
    include_examples "POST form", :operator_address_lookup_form, "/operator-address-lookup" do
      let(:form_data) { { temp_address: "340116" } }
      let(:invalid_form_data) { [{ temp_address: nil }] }
    end

    include_examples "skip to manual address",
                     :operator_address_lookup_form,
                     request_path: "/operator-address-lookup/skip_to_manual_address",
                     result_path: "/operator-address-manual"
  end
end
