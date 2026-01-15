# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Site Grid Reference Forms" do
    let(:site_grid_reference_request_path) { site_grid_reference_forms_path(token: form.token) }
    let(:form) { build(:site_grid_reference_form) }

    it_behaves_like "GET form", :site_grid_reference_form, "/site-grid-reference"
    it_behaves_like "POST form", :site_grid_reference_form, "/site-grid-reference" do
      let(:form_data) do
        {
          grid_reference: "ST 58337 72855",
          description: "The waste is stored in an out-building next to the barn.",
          is_linear: false
        }
      end

      let(:invalid_form_data) do
        [
          {
            grid_reference: nil,
            description: nil
          }
        ]
      end
    end

    describe "GET site_address_request_path" do
      context "with skip to check site address form" do
        let(:site_address_request_path) { skip_to_address_site_grid_reference_forms_path(token: form.token) }

        it "renders the appropriate template" do
          get site_address_request_path

          expect(response.location).to include(site_postcode_forms_path(token: form.token))
        end

        it "returns a 303 status code" do
          get site_address_request_path

          expect(response).to have_http_status(:see_other)
        end
      end

      describe "GET site_grid_reference_request_path" do
        shared_examples "does not show the linear checkbox" do
          it do
            get site_grid_reference_request_path

            expect(response.body).not_to include(I18n.t(".waste_exemptions_engine.site_grid_reference_forms.new.mark_as_linear"))
          end
        end

        context "when the form is loaded in the front-office" do
          before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false) }

          it_behaves_like "does not show the linear checkbox"
        end

        context "when the form is loaded in the back-office" do
          before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true) }

          context "when the transient registration is multi-site" do
            before { form.transient_registration.update(is_multisite_registration: true) }

            it_behaves_like "does not show the linear checkbox"
          end

          context "when the transient registration is single-site" do
            before { form.transient_registration.update(is_multisite_registration: false) }

            it "includes the linear checkbox" do
              get site_grid_reference_request_path

              expect(response.body).to include(I18n.t(".waste_exemptions_engine.site_grid_reference_forms.new.mark_as_linear"))
            end
          end
        end
      end
    end

    describe "POST site_grid_reference_request_path" do
      let(:form_data) do
        {
          grid_reference: "ST 58337 72855",
          description: "The waste is stored in an out-building next to the barn.",
          is_linear: false
        }
      end

      context "when the form is submitted in the front-office" do
        before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false) }

        it "does not change the is_linear attribute" do
          expect { post site_grid_reference_request_path, params: { site_grid_reference_form: form_data } }
            .not_to change { form.transient_registration.reload.is_linear }.from(false)
        end
      end

      context "when the form is submitted in the back-office" do
        before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true) }

        context "when the linear checkbox is not checked" do
          it "does not change the is_linear attribute" do
            expect { post site_grid_reference_request_path, params: { site_grid_reference_form: form_data } }
              .not_to change { form.transient_registration.reload.is_linear }.from(false)
          end
        end

        context "when the linear checkbox is checked" do
          before { form_data[:is_linear] = true }

          it "changes the is_linear attribute" do
            expect { post site_grid_reference_request_path, params: { site_grid_reference_form: form_data } }
              .to change { form.transient_registration.reload.is_linear }.to(true)
          end
        end
      end
    end

    context "when editing an existing registration" do
      let(:edit_site_grid_reference_form) { build(:edit_site_grid_reference_form) }

      it "pre-fills site grid reference information" do
        get "/waste_exemptions_engine/#{edit_site_grid_reference_form.token}/site-grid-reference"

        aggregate_failures do
          expect(response.body).to have_html_escaped_string(edit_site_grid_reference_form.grid_reference)
          expect(response.body).to have_html_escaped_string(edit_site_grid_reference_form.description)
        end
      end
    end

    context "when editing site grid reference on Check Your Answers page - new registration" do
      let(:check_site_address_form) { build(:check_your_answers_check_site_address_form) }
      let(:transient_registration) { create(:new_charged_registration, workflow_state: "check_site_address_form") }

      context "when reusing the operator address" do
        let(:form_data) { { temp_reuse_address_for_site_location: "operator_address_option" } }

        it "redirects back to check-your-answers when submitted" do
          post "/waste_exemptions_engine/#{check_site_address_form.token}/check-site-address",
               params: { check_site_address_form: form_data }
          expect(response).to redirect_to(check_your_answers_forms_path(check_site_address_form.token))
        end
      end

      context "when selecting another address" do
        let(:form_data) { { temp_reuse_address_for_site_location: "a_different_address" } }

        it "redirects to the post code form when submitted" do
          post "/waste_exemptions_engine/#{check_site_address_form.token}/check-site-address",
               params: { check_site_address_form: form_data }
          expect(response).to redirect_to(site_postcode_forms_path(check_site_address_form.token))
        end
      end
    end
  end
end
