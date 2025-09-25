# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Register In Northern Ireland Forms" do
    it_behaves_like "GET form", :register_in_northern_ireland_form, "/register-in-northern-ireland"
    it_behaves_like "unable to POST form", :register_in_northern_ireland_form, "/register-in-northern-ireland"
  end
end
