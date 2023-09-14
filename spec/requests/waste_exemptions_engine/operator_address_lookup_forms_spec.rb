# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Operator Address Lookup Forms", :vcr do
    before { VCR.insert_cassette("postcode_valid", allow_playback_repeats: true) }
    after { VCR.eject_cassette }

    include_examples "GET form", :operator_address_lookup_form, "/operator-address-lookup"
    include_examples "POST form", :operator_address_lookup_form, "/operator-address-lookup" do
      let(:form_data) { { operator_address: { uprn: "340116" } } }
      let(:invalid_form_data) { [{ operator_address: { uprn: nil } }] }
    end

    include_examples "skip to manual address",
                     :operator_address_lookup_form,
                     address_type: :operator
  end
end
