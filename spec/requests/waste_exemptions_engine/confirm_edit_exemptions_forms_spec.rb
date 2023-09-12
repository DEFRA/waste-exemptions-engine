# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "confirm edit exemptions form" do
    let(:request_path) { "/waste_exemptions_engine/#{form.token}/confirm-edit-exemptions" }
    let(:transient_registration_factory) { :renewing_registration }
    let(:form) { build(:confirm_edit_exemptions_form, transient_registration_factory:) }

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
      shared_examples "common form submission behaviour" do
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

          it "does not remove any exemptions" do
            expect { post request_path, params: valid_params }
              .not_to change { transient_registration.reload.exemptions.length }
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

          it "redirects to the correct workflow step" do
            post request_path, params: valid_params

            aggregate_failures do
              expect(response).to have_http_status(:see_other)
              expect(response).to redirect_to("/waste_exemptions_engine/#{form.token}/#{next_page_if_confirmed}")
            end
          end

          it "removes the exemptions selected for removal" do
            aggregate_failures do
              previous_exemption_count = exemptions.count

              post request_path, params: valid_params

              current_exemptions = transient_registration.reload.exemptions

              expect(current_exemptions.length).to eq(previous_exemption_count - 2)
              expect(current_exemptions).not_to include(exemptions.first)
              expect(current_exemptions).not_to include(exemptions.last)
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

      context "with a renewing registration" do
        let(:transient_registration_factory) { :renewing_registration }
        let(:next_page_if_confirmed) { "edit-exemptions-declaration" }

        it_behaves_like "common form submission behaviour"
      end

      context "with a front-office edit registration" do
        let(:transient_registration_factory) { :front_office_edit_registration }
        let(:next_page_if_confirmed) { "fo_edit" }

        it_behaves_like "common form submission behaviour"
      end
    end
  end
end
