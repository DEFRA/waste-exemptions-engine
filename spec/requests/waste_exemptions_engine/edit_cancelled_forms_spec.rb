# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Edit Cancelled Forms", type: :request do
    let(:form) { build(:edit_cancelled_form) }
    let(:edit_enabled) { "true" }
    before(:each) do
      WasteExemptionsEngine.configuration.edit_enabled = edit_enabled
    end

    describe "GET edit_cancelled_form" do
      let(:request_path) { "/waste_exemptions_engine/edit-cancelled/#{form.token}" }

      it "renders the appropriate template" do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/edit_cancelled_forms/new")
      end

      it "responds to the GET request with a 200 status code" do
        get request_path
        expect(response.code).to eq("200")
      end

      it "returns W3C valid HTML content", vcr: true do
        get request_path
        expect(response.body).to have_valid_html
      end

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is anything other than \"true\"" do
        let(:edit_enabled) { "false" }

        it "raises a page not found error" do
          expect { get request_path }.to raise_error(ActionController::RoutingError)
        end

        it "returns a 404 status page" do
          rails_respond_without_detailed_exceptions do
            get request_path

            expect(response.body).to include(I18n.t("waste_exemptions_engine.errors.error_404.clarification"))
          end
        end
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "/waste_exemptions_engine/edit-cancelled/back/#{form.token}" }

      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    include_examples "unable to POST form", :edit_cancelled_form, "/edit-cancelled"
  end
end
