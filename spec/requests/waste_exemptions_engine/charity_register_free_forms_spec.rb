# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Charity Register Free Forms" do
    let(:form) { build(:charity_register_free_form) }
    let(:request_path) { "/waste_exemptions_engine/#{form.token}/charity-register-free" }

    describe "GET charity_register_free_form" do
      it "renders the appropriate template" do
        get request_path

        expect(response).to render_template("waste_exemptions_engine/charity_register_free_forms/new")
      end

      it "returns a 200 status" do
        get request_path

        expect(response).to have_http_status(:ok)
      end

      it "returns valid HTML content", :ignore_hidden_autocomplete do
        get request_path

        expect(response.body).to have_valid_html
      end
    end
  end
end
