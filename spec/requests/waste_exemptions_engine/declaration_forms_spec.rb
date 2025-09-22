# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Declaration Forms" do

    it_behaves_like "GET form", :declaration_form, "/declaration"

    it_behaves_like "POST form", :declaration_form, "/declaration" do
      let(:form_data) { { declaration: 1 } }
      let(:invalid_form_data) { [{ declaration: 0 }] }
    end
  end
end
