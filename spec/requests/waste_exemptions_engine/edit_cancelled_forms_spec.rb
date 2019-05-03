# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Edit Cancelled Forms", type: :request do
    let(:form) { build(:edit_cancelled_form) }

    describe "GET edit_cancelled_form" do
      let(:request_path) { "/waste_exemptions_engine/edit-cancelled/#{form.token}" }

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"true\"" do
        before(:each) do
          WasteExemptionsEngine.configuration.edit_enabled = "true"
        end

        it "renders the appropriate template" do
          get request_path
          expect(response).to render_template("waste_exemptions_engine/edit_cancelled_forms/new")
        end

        it "responds to the GET request with a 200 status code" do
          get request_path
          expect(response.code).to eq("200")
        end
      end

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is anything other than \"true\"" do
        before(:each) { WasteExemptionsEngine.configuration.edit_enabled = "false" }

        it "renders the error_404 template" do
          get request_path
          expect(response.location).to include("errors/404")
        end

        it "responds with a status of 404" do
          get request_path
          expect(response.code).to eq("404")
        end

        it "does not call the EditCancellationService" do
          expect(EditCancellationService).to_not receive(:run)
          get request_path
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
