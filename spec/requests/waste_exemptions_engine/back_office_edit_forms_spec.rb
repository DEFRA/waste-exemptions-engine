# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Edit Forms" do
    let(:form) { build(:back_office_edit_form) }

    describe "GET back_office_edit_form" do
      before do
        WasteExemptionsEngine.configuration.edit_enabled = edit_enabled
      end

      let(:request_path) { "/waste_exemptions_engine/#{form.token}/edit" }

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"true\"" do
        let(:edit_enabled) { "true" }

        it "renders the appropriate template, returns a 200 status code and W3C valid HTML content", :vcr do
          get request_path

          aggregate_failures do
            expect(response).to render_template("waste_exemptions_engine/back_office_edit_forms/new")
            expect(response).to have_http_status(:ok)
            expect(response.body).to have_valid_html
          end
        end

        context "when the token is a registration reference" do
          let(:registration) { create(:registration, :complete) }

          let(:request_path) { "/waste_exemptions_engine/#{registration.reference}/edit" }

          it "renders the appropriate template, returns a 200 status code and loads the correct page" do
            get request_path

            aggregate_failures do
              expect(response).to render_template("waste_exemptions_engine/back_office_edit_forms/new")
              expect(response).to have_http_status(:ok)
              expect(response.body).to include(registration.reference)
            end
          end

          context "when the registration doesn't have an edit in progress" do
            it "creates a new BackOfficeEditRegistration for the registration" do
              expect { get request_path }.to change { BackOfficeEditRegistration.where(reference: registration.reference).count }.from(0).to(1)
            end
          end

          context "when the registration already has an edit in progress" do
            let(:edit_registration) { create(:back_office_edit_registration) }
            let(:request_path) { "/waste_exemptions_engine/#{edit_registration.reference}/edit/" }

            it "does not create a new BackOfficeEditRegistration for the registration" do
              expect { get request_path }.not_to change { BackOfficeEditRegistration.where(reference: edit_registration.reference).count }.from(1)
            end
          end
        end

        context "when the token is not a registration reference" do
          let(:request_path) { "/waste_exemptions_engine/WEX987654/edit" }

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

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"false\"" do
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
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/edit/back" }

      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "POST back_office_edit_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/edit/" }

      before do
        WasteExemptionsEngine.configuration.edit_enabled = edit_enabled
      end

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"true\"" do
        let(:edit_enabled) { "true" }

        status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

        # A successful POST request redirects to the next form in the work flow. We have chosen to
        # differentiate 'good' rediection as 303 and 'bad' redirection as 302.
        it "responds to the POST request with a #{status_code} status code" do
          post request_path
          expect(response.code).to eq(status_code.to_s)
        end
      end

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"false\"" do
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

    %w[applicant_name
       applicant_phone
       applicant_email
       main_people
       registration_number
       operator_name
       operator_postcode
       contact_name
       contact_position
       contact_phone
       contact_email
       contact_postcode
       on_a_farm
       is_a_farmer
       site_grid_reference].each do |edit_action|
      describe "GET edit_#{edit_action}" do
        let(:request_path) { "/waste_exemptions_engine/#{form.token}/edit/#{edit_action}" }

        before do
          WasteExemptionsEngine.configuration.edit_enabled = edit_enabled
        end

        context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"true\"" do
          let(:edit_enabled) { "true" }
          let(:next_workflow_state) { "#{edit_action}_form" }
          let(:redirection_path) do
            send("new_#{next_workflow_state}_path".to_sym, form.transient_registration.token)
          end

          status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

          it "redirects to the appropriate location" do
            get request_path
            expect(response.location).to include(redirection_path)
          end

          it "responds to the GET request with a #{status_code} status code" do
            get request_path
            expect(response.code).to eq(status_code.to_s)
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
    end
  end
end
