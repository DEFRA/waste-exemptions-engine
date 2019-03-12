# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Your Answers Forms", type: :request, vcr: true do
    before(:context) do
      create_list(:exemption, 5)
      VCR.insert_cassette("company_no_valid", allow_playback_repeats: true)
    end
    after(:context) { VCR.eject_cassette }

    empty_form_is_valid = true
    include_examples "GET form", :check_your_answers_form, "/check-your-answers"
    include_examples "go back", :check_your_answers_form, "/check-your-answers/back"
    include_examples "POST form", :check_your_answers_form, "/check-your-answers", empty_form_is_valid do
      let(:form_data) { {} }
    end
  end
end
