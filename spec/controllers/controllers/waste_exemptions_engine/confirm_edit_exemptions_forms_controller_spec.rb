# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmEditExemptionsFormsController, type: :request do
    let(:request_path) { "/waste_exemptions_engine/#{form.token}/confirm-edit-exemptions" }
    let(:form) { build(:confirm_edit_exemptions_form) }

    it "is a FormController" do
      expect(described_class.superclass).to eq(WasteExemptionsEngine::FormsController)
    end

    describe "#new" do
      it "renders the correct template" do
        get request_path

        aggregate_failures do
          expect(response.code).to eq("200")
          expect(response).to render_template("waste_exemptions_engine/confirm_edit_exemptions_forms/new")
        end
      end
    end

    describe "#create" do
      context "when selecting the no option" do
        let(:valid_params) do
          {
            confirm_edit_exemptions_form: {
              workflow_state: "edit_exemptions_form"
            }
          }
        end

        it "redirects to the correct workflow step" do
          post request_path, params: valid_params

          aggregate_failures do
            expect(response.code).to eq("303")
            expect(response).to redirect_to("/waste_exemptions_engine/#{form.token}/edit-exemptions")
          end
        end
      end

      context "when selecting the yes option" do
        let(:valid_params) do
          {
            confirm_edit_exemptions_form: {
              workflow_state: "edit_exemptions_declaration_form"
            }
          }
        end

        it "redirects to the correct workflow step" do
          post request_path, params: valid_params

          aggregate_failures do
            expect(response.code).to eq("303")
            expect(response).to redirect_to("/waste_exemptions_engine/#{form.token}/edit-exemptions-declaration")
          end
        end
      end

      context "when an invalid workflow_state has been provided" do
        let(:invalid_params) do
          {
            confirm_edit_exemptions_form: {
              workflow_state: "renewal_start"
            }
          }
        end

        it "re-renders the new template and displays a validation error" do
          post request_path, params: invalid_params

          aggregate_failures do
            expect(response.code).to eq("200")
            expect(response).to render_template("waste_exemptions_engine/confirm_edit_exemptions_forms/new")
            expect(response.body).to have_html_escaped_string("You must select Yes or No")
          end
        end
      end

      context "when no workflow_state has been provided" do
        let(:invalid_params) do
          {
            confirm_edit_exemptions_form: {}
          }
        end

        it "re-renders the new template and displays a validation error" do
          post request_path, params: invalid_params

          aggregate_failures do
            expect(response.code).to eq("200")
            expect(response).to render_template("waste_exemptions_engine/confirm_edit_exemptions_forms/new")
            expect(response.body).to have_html_escaped_string("You must select Yes or No")
          end
        end
      end
    end
  end
end
