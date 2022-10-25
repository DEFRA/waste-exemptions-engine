# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Site Address Forms" do
    include_examples "GET form", :check_site_address_form, "/check-site-address"
    include_examples "POST form", :check_site_address_form, "/check-site-address" do
      let(:form_data) { { temp_reuse_address_for_site_location: "a_different_address" } }
      let(:invalid_form_data) { [{ temp_reuse_address_for_site_location: " " }] }
    end
  end
end
