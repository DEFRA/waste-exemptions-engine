# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Exemptions Summary Forms" do
    let(:form) { build(:exemptions_summary_form) }

    describe "GET exemptions_summary_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/exemptions-summary" }

      it "renders the appropriate template", :vcr do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/exemptions_summary_forms/new")
      end

      it "returns a 200 status code", :vcr do
        get request_path
        expect(response).to have_http_status(:ok)
      end

      it "returns W3C valid HTML content", :vcr, :ignore_hidden_autocomplete do
        get request_path
        expect(response.body).to have_valid_html
      end

      context "with a farm bucket" do

        include_context "farm bucket"

        before do
          form.transient_registration.order = build(:order)
          form.transient_registration.order.update(bucket: Bucket.farmer_bucket)
          form.transient_registration.exemptions << farm_exemptions
          form.transient_registration.update(is_multisite_registration: true)
        end

        it "includes the farming exemptions", :vcr do
          get request_path
          Bucket.farmer_bucket.exemptions.pluck(:code).each do |exemption_code|
            expect(response.body).to include(exemption_code)
          end
        end
      end

      # To address edge-case defect as reported in https://eaflood.atlassian.net/browse/RUBY-4088?focusedCommentId=814733
      context "when multisite with discounted charges" do
        include_context "with bands and charges"
        include_context "with an order with exemptions"

        let(:exemptions) { multiple_bands_multiple_exemptions }

        before do
          form.transient_registration.order = order
          form.transient_registration.exemptions << exemptions
          form.transient_registration.update(is_multisite_registration: true)
        end

        it "loads without error" do
          get request_path
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "POST exemptions_summary_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/exemptions-summary" }
      let(:request_body) { { exemptions_summary_form: { token: form.token } } }

      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      it "responds to the POST request with a #{status_code} status code" do
        post request_path, params: request_body
        expect(response.code).to eq(status_code.to_s)
      end

      it "redirects to the site grid reference form" do
        post request_path, params: request_body
        expect(response).to redirect_to(site_grid_reference_forms_path(form.token))
      end
    end

    context "when on Exemptions Summary page during Check Your Answers flow - new registration" do
      let(:exemptions_summary_form) { build(:check_your_answers_exemptions_summary_form) }

      it "directs to check your answers when submitted" do
        post "/waste_exemptions_engine/#{exemptions_summary_form.token}/exemptions-summary",
             params: { exemptions_summary_form: { token: exemptions_summary_form.token } }

        expect(response).to redirect_to(check_your_answers_forms_path(exemptions_summary_form.token))
      end
    end
  end
end
