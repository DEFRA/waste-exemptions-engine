# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Operator Name Forms", type: :request do
    include_examples "GET form", :operator_name_form, "/operator-name"
    include_examples "go back", :operator_name_form, "/operator-name/back"
    include_examples "POST form", :operator_name_form, "/operator-name" do
      let(:form_data) { { operator_name: "Acme Waste Carriers" } }
      let(:invalid_form_data) { [{ operator_name: nil }] }
    end
  end
end
