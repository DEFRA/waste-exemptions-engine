# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Location Forms" do
    include_examples "GET form", :location_form, "/location"
    include_examples "POST form", :location_form, "/location" do
      let(:form_data) { { location: "england" } }
      let(:invalid_form_data) { [{ location: nil }] }
    end
  end
end
