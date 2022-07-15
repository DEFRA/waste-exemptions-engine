# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Register In Scotland Forms", type: :request do
    include_examples "GET form", :register_in_scotland_form, "/register-in-scotland"
    include_examples "unable to POST form", :register_in_scotland_form, "/register-in-scotland"
  end
end
