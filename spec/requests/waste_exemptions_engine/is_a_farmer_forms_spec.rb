# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Is a Farmer Forms", type: :request do
    include_examples "GET form", :is_a_farmer_form, "/is-a-farmer"
    include_examples "go back", :is_a_farmer_form, "/is-a-farmer/back"
    include_examples "POST form", :is_a_farmer_form, "/is-a-farmer" do
      let(:form_data) { { is_a_farmer: "true" } }
    end
  end
end
