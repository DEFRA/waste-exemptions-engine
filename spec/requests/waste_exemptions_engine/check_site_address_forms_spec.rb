# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Check Site Address Forms", type: :request do
    include_examples "GET form", :check_site_address_form, "/check-site-address"
    include_examples "go back", :check_site_address_form, "/check-site-address/back"
  end
end
