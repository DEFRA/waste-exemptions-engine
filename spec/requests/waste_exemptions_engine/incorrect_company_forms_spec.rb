# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Incorrect Company Forms", type: :request do
    empty_form_is_valid = true
    include_examples "GET form", :incorrect_company_form, "/incorrect-company"
    include_examples "POST form", :incorrect_company_form, "/incorrect-company", empty_form_is_valid do
      let(:form_data) { {} }
      let(:invalid_form_data) { [] }
    end
  end
end
