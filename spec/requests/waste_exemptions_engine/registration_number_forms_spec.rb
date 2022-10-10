# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Number Forms", type: :request, vcr: true do
    before { VCR.insert_cassette("company_no_valid", allow_playback_repeats: true) }
    after { VCR.eject_cassette }

    include_examples "GET form", :registration_number_form, "/registration-number"
    include_examples "POST form", :registration_number_form, "/registration-number" do
      let(:form_data) { { company_no: "09360070" } }
      let(:invalid_form_data) { [{ company_no: nil }] }
    end
  end
end
