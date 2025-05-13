# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Edit Cancelled Forms" do
    let(:form) { build(:back_office_edit_cancelled_form) }
    let(:edit_enabled) { "true" }

    before do
      WasteExemptionsEngine.configuration.edit_enabled = edit_enabled
    end

    describe "GET back_office_edit_cancelled_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/edit-cancelled" }

      it "renders the appropriate template, returns a 200 status code and W3C valid HTML content" do
        get request_path

        aggregate_failures do
          expect(response).to render_template("waste_exemptions_engine/back_office_edit_cancelled_forms/new")
          expect(response).to have_http_status(:ok)
          expect(response.body).to have_valid_html
        end
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
      let(:request_path) { "/waste_exemptions_engine/edit-cancelled/#{form.token}/back" }

      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    include_examples "unable to POST form", :back_office_edit_cancelled_form, "/edit-cancelled"
  end
end
