# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Charitable Purpose Declaration Forms" do

    it_behaves_like "GET form", :charitable_purpose_declaration_form, "/charitable-purpose-declaration"

    it_behaves_like "POST form", :charitable_purpose_declaration_form, "/charitable-purpose-declaration" do
      let(:form_data) { { charitable_purpose_declaration: 1 } }
      let(:invalid_form_data) { [{ charitable_purpose_declaration: 0 }] }
    end
  end
end
