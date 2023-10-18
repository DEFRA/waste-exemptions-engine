# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Renewal Start Forms" do
    let(:form) { build(:renewal_start_form) }

    describe "GET renewal_start_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/renewal-start" }

      it "renders the appropriate template", :vcr do
        get request_path

        expect(response).to render_template("waste_exemptions_engine/renewal_start_forms/new")
      end

      it "returns a 200 status code", :vcr do
        get request_path

        expect(response).to have_http_status(:ok)
      end

      it "returns W3C valid HTML content", :vcr, :ignore_hidden_autocomplete do
        get request_path

        expect(response.body).to have_valid_html
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/renewal-complete/back" }

      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    include_examples "POST form", :renewal_start_form, "/renewal-start" do
      let(:form_data) { { temp_renew_without_changes: "true" } }
      let(:invalid_form_data) { [] }
    end
  end
end
