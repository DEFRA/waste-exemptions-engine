# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Business Type Forms" do
    it_behaves_like "GET form", :business_type_form, "/business-type"
    it_behaves_like "POST form", :business_type_form, "/business-type" do
      let(:form_data) { { business_type: "limitedCompany" } }
      let(:invalid_form_data) { [{ business_type: nil }] }
    end
  end
end
