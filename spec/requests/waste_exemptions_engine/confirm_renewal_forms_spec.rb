# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renew Without Changes Forms" do
    let(:form) { build(:confirm_renewal_form) }

    describe "GET confirm_renewal_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/confirm-renewal" }

      it "renders the appropriate template", :vcr do
        get request_path

        expect(response).to render_template("waste_exemptions_engine/confirm_renewal_forms/new")
      end

      it "returns a 200 status code", :vcr do
        get request_path

        expect(response).to have_http_status(:ok)
      end

      it "returns W3C valid HTML content", :vcr do
        get request_path

        expect(response.body).to have_valid_html
      end
    end

    empty_form_is_valid = true
    include_examples "POST form", :confirm_renewal_form, "/confirm-renewal", empty_form_is_valid do
      let(:form_data) { {} }
      let(:invalid_form_data) { [] }
    end
  end
end
