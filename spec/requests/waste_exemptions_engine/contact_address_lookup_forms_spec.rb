# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Address Lookup Forms", type: :request, vcr: true do
    before { VCR.insert_cassette("postcode_valid", allow_playback_repeats: true) }
    after { VCR.eject_cassette }

    include_examples "GET form", :contact_address_lookup_form, "/contact-address-lookup"
    include_examples "POST form", :contact_address_lookup_form, "/contact-address-lookup" do
      let(:form_data) { { contact_address: { uprn: "340116" } } }
      let(:invalid_form_data) { [{ contact_address: { uprn: nil } }] }
    end

    include_examples "skip to manual address",
                     :contact_address_lookup_form,
                     address_type: :contact
  end
end
