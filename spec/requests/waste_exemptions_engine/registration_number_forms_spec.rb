# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Number Forms", type: :request do
    before(:context) { VCR.insert_cassette("company_no_valid", allow_playback_repeats: true) }
    after(:context) { VCR.eject_cassette }
    include_examples "GET form", :registration_number_form, "/registration-number"
    include_examples "go back", :registration_number_form, "/registration-number/back"
    include_examples "POST form", :registration_number_form, "/registration-number" do
      let(:form_data) { { company_no: "09360070" } }
    end
  end
end
