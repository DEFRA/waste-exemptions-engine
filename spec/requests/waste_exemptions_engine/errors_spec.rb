# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Errors" do
    describe "#show" do
      %w[401 403 404 422].each do |code|
        it "renders the error_#{code} template, responds with a status of #{code}, returns W3C valid HTML content", :vcr do
          get error_path(code)

          expect(response).to render_template("error_#{code}")
          expect(response.code).to eq(code)
          expect(response.body).to have_valid_html
        end
      end

      it "renders the generic error template when no matching error template exists" do
        get error_path("601")

        expect(response).to have_http_status(:internal_server_error)
        expect(response).to render_template(:error_generic)
      end

      it "correctly redirects page not found errors to the correct internal view" do
        rails_respond_without_detailed_exceptions do
          get "/this-page-does-not-exist"

          expect(response).to have_http_status(:not_found)
          expect(response.body).to include(I18n.t("waste_exemptions_engine.errors.error_404.clarification"))
        end
      end
    end
  end
end
