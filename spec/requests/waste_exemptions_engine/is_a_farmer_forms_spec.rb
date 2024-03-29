# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Is a Farmer Forms" do
    include_examples "GET form", :is_a_farmer_form, "/is-a-farmer"
    include_examples "POST form", :is_a_farmer_form, "/is-a-farmer" do
      let(:form_data) { { is_a_farmer: "true" } }
      let(:invalid_form_data) { [] }
    end
  end
end
