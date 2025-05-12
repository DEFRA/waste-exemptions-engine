# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Location Forms" do
    it_behaves_like "GET form", :location_form, "/location"
    it_behaves_like "POST form", :location_form, "/location" do
      let(:form_data) { { location: "england" } }
      let(:invalid_form_data) { [{ location: nil }] }
    end
  end
end
