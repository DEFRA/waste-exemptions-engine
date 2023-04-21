# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renew Without Changes Forms" do
    let(:form) { build(:renew_without_changes_form) }

    describe "GET renew_without_changes_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/renew-without-changes" }

      it "renders the appropriate template, returns a 200 status code and W3C valid HTML content", vcr: true do
        get request_path

        expect(response).to render_template("waste_exemptions_engine/renew_without_changes_forms/new")
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_valid_html
      end
    end

    empty_form_is_valid = true
    include_examples "POST form", :renew_without_changes_form, "/renew-without-changes", empty_form_is_valid do
      let(:form_data) { {} }
      let(:invalid_form_data) { [] }
    end
  end
end
