# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "On a Farm Forms", type: :request do
    include_examples "GET form", :on_a_farm_form, "/on-a-farm"
    include_examples "POST form", :on_a_farm_form, "/on-a-farm" do
      let(:form_data) { { on_a_farm: "true" } }
      let(:invalid_form_data) { [] }
    end
  end
end
