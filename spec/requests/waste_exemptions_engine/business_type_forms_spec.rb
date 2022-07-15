# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Business Type Forms", type: :request do
    include_examples "GET form", :business_type_form, "/business-type"
    include_examples "POST form", :business_type_form, "/business-type" do
      let(:form_data) { { business_type: "limitedCompany" } }
      let(:invalid_form_data) { [{ business_type: nil }] }
    end
  end
end
