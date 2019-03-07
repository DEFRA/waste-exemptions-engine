# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Your Answers Forms", type: :request do
    before(:context) { create_list(:exemption, 5) }

    include_examples "GET form", :check_your_answers_form, "/check-your-answers"
    include_examples "go back", :check_your_answers_form, "/check-your-answers/back"
    include_examples "POST form", :check_your_answers_form, "/check-your-answers" do
      let(:form_data) { {} }

      before(:each) { VCR.insert_cassette("company_no_valid") }
      after(:each) { VCR.eject_cassette }
    end
  end
end
