# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Applicant Phone Forms", type: :request do
    include_examples "GET form", :applicant_phone_form, "/applicant-phone"
    include_examples "go back", :applicant_phone_form, "/applicant-phone/back"
    include_examples "POST form", :applicant_phone_form, "/applicant-phone" do
      let(:form_data) { { phone_number: "01234567890" } }
    end
  end
end
