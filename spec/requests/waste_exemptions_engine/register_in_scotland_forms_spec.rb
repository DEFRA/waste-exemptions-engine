# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Register In Scotland Forms" do
    it_behaves_like "GET form", :register_in_scotland_form, "/register-in-scotland"
    it_behaves_like "unable to POST form", :register_in_scotland_form, "/register-in-scotland"
  end
end
