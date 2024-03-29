# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Declaration Forms" do

    include_examples "GET form", :declaration_form, "/declaration"

    include_examples "POST form", :declaration_form, "/declaration" do
      let(:form_data) { { declaration: 1 } }
      let(:invalid_form_data) { [{ declaration: 0 }] }
    end
  end
end
