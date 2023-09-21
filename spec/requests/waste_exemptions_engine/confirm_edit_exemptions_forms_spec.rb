# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "confirm edit exemptions form" do
    let(:request_path) { "/waste_exemptions_engine/#{form.token}/confirm-edit-exemptions" }
    let(:form) { build(:confirm_edit_exemptions_form) }

    describe "#new" do
      it "renders the correct template" do
        get request_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template("waste_exemptions_engine/confirm_edit_exemptions_forms/new")
        end
      end
    end

    describe "#create" do
      before do
        transient_registration.excluded_exemptions = exemption_ids_to_remove
        transient_registration.save!
      end

      let(:transient_registration) { form.transient_registration }
      let(:exemptions) { transient_registration.exemptions }
      let(:exemption_ids_to_remove) { [exemptions.first, exemptions.last].pluck(:id) }
      let(:exemption_ids_to_retain) { (exemptions.pluck(:id) - exemption_ids_to_remove) }

      context "when selecting the no option" do
        let(:valid_params) do
          {
            confirm_edit_exemptions_form: {
              exemption_ids: exemption_ids_to_retain,
              temp_confirm_exemption_edits: "false"
            }
          }
        end

        it "redirects to the correct workflow step" do
          post request_path, params: valid_params

          aggregate_failures do
            expect(response).to have_http_status(:see_other)
            expect(response).to redirect_to("/waste_exemptions_engine/#{form.token}/edit-exemptions")
          end
        end

        it "does not cease any exemptions" do
          expect { post request_path, params: valid_params }
            .not_to change { transient_registration.reload.exemption_ids.length }
        end
      end

      context "when selecting the yes option" do
        let(:valid_params) do
          {
            confirm_edit_exemptions_form: {
              exemption_ids: exemption_ids_to_retain,
              temp_confirm_exemption_edits: "true"
            }
          }
        end

        context "with a subset of exemptions removed" do
          let(:exemption_ids_to_remove) { [exemptions.first, exemptions.last].pluck(:id) }

          it "redirects to the main edit page" do
            post request_path, params: valid_params

            aggregate_failures do
              expect(response).to have_http_status(:see_other)
              expect(response).to redirect_to("/waste_exemptions_engine/#{form.token}/fo_edit")
            end
          end

          it "removes the ids of the exemptions selected for removal" do
            expect { post request_path, params: valid_params }
              .to change { transient_registration.reload.exemption_ids.length }.by(-2)
          end
        end

        context "with all exemptions removed" do
          let(:exemption_ids_to_remove) { exemptions.pluck(:id) }

          it "redirects to the deregistration declaration page" do
            post request_path, params: valid_params

            aggregate_failures do
              expect(response).to have_http_status(:see_other)
              expect(response).to redirect_to("/waste_exemptions_engine/#{form.token}/edit-exemptions-declaration")
            end
          end
        end
      end

      context "when an invalid option value has been provided" do
        let(:invalid_params) do
          {
            confirm_edit_exemptions_form: {
              temp_confirm_exemption_edits: nil
            }
          }
        end

        it "re-renders the new template and displays a validation error" do
          post request_path, params: invalid_params

          aggregate_failures do
            expect(response).to have_http_status(:ok)
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
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("waste_exemptions_engine/confirm_edit_exemptions_forms/new")
            expect(response.body).to have_html_escaped_string("You must select Yes or No")
          end
        end
      end
    end
  end
end
