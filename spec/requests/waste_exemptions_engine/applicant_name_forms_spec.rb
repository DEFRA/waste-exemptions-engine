# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Applicant Name Forms", type: :request do
    include_examples "GET form", :applicant_name_form, "/applicant-name"
    include_examples "go back", :applicant_name_form, "/applicant-name/back"
    include_examples "POST form", :applicant_name_form, "/applicant-name" do
      let(:form_data) { { first_name: "Joe", last_name: "Bloggs" } }
    end
  end
end
