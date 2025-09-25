# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Register In Wales Forms" do
    it_behaves_like "GET form", :register_in_wales_form, "/register-in-wales"
    it_behaves_like "unable to POST form", :register_in_wales_form, "/register-in-wales"
  end
end
