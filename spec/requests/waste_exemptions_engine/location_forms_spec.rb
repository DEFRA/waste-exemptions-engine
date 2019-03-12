# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Location Forms", type: :request do
    include_examples "GET form", :location_form, "/location"
    include_examples "go back", :location_form, "/location/back"
    include_examples "POST form", :location_form, "/location" do
      let(:form_data) { { location: "england" } }
    end
  end
end
