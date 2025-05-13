# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Register In Wales Forms" do
    include_examples "GET form", :register_in_wales_form, "/register-in-wales"
    include_examples "unable to POST form", :register_in_wales_form, "/register-in-wales"
  end
end
