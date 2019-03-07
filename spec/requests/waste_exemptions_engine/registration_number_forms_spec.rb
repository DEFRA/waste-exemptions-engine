# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registration Number Forms", type: :request do
    include_examples "GET form", :registration_number_form, "/registration-number"
    include_examples "go back", :registration_number_form, "/registration-number/back"
    include_examples "POST form", :registration_number_form, "/registration-number" do
      let(:form_data) { { company_no: "sc534714" } }

      before(:each) { VCR.insert_cassette("company_no_valid") }
      after(:each) { VCR.eject_cassette }
    end
  end
end
