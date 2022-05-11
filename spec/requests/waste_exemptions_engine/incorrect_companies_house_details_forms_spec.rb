# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Incorrect Companies House Details Forms", type: :request do
    empty_form_is_valid = true
    include_examples "GET form", :incorrect_companies_house_details_form, "/incorrect-companies-house-details"
    include_examples "go back", :incorrect_companies_house_details_form, "/incorrect-companies-house-details/back"
    include_examples "POST form", :incorrect_companies_house_details_form, "/incorrect-companies-house-details", empty_form_is_valid do
      let(:form_data) { {} }
      let(:invalid_form_data) { [] }
    end
  end
end
