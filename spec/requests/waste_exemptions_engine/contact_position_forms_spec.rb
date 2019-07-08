# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Contact Position Forms", type: :request do
    include_examples "GET form", :contact_position_form, "/contact-position"
    include_examples "go back", :contact_position_form, "/contact-position/back"

    empty_form_is_valid = true
    include_examples "POST form", :contact_position_form, "/contact-position", empty_form_is_valid do
      let(:form_data) { { position: "Chief Waste Carrier" } }
      let(:invalid_form_data) { [] }
    end
  end
end
