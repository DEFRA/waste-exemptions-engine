# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Charity Register Free Forms" do
    include_examples "GET form", :charity_register_free_form, "/charity-register-free"
  end
end
