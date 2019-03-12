# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Register In Northern Ireland Forms", type: :request do
    include_examples "GET form", :register_in_northern_ireland_form, "/register-in-northern-ireland"
    include_examples "go back", :register_in_northern_ireland_form, "/register-in-northern-ireland/back"
    include_examples "unable to POST form", :register_in_northern_ireland_form, "/register-in-northern-ireland"
  end
end
