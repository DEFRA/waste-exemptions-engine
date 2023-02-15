# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditExemptionsDeclarationFormsController, type: :request do
    let(:request_path) { "/waste_exemptions_engine/#{form.token}/edit-exemptions-declaration" }
    let(:form) { build(:edit_exemptions_declaration_form) }

    it "is a FormController" do
      expect(described_class.superclass).to eq(WasteExemptionsEngine::FormsController)
    end

    describe "#new" do
      it "renders the correct template" do
        get request_path

        aggregate_failures do
          expect(response.code).to eq("200")
          expect(response).to render_template("waste_exemptions_engine/edit_exemptions_declaration_forms/new")
        end
      end
    end

    describe "#create" do
      context "when given valid parameters" do
        let(:valid_params) do
          {
            edit_exemptions_declaration_form: {
              declaration: "1"
            }
          }
        end

        it "redirects to the correct workflow step" do
          post request_path, params: valid_params

          aggregate_failures do
            expect(response.code).to eq("303")
            expect(response).to redirect_to("/waste_exemptions_engine/#{form.token}/edit-exemptions-success")
          end
        end
      end

      context "when given invalid parameters" do
        let(:invalid_params) do
          {
            edit_exemptions_declaration_form: {}
          }
        end

        it "redirects to the correct workflow step" do
          post request_path, params: invalid_params

          aggregate_failures do
            expect(response.code).to eq("200")
            expect(response).to render_template("waste_exemptions_engine/edit_exemptions_declaration_forms/new")
          end
        end
      end
    end
  end
end
