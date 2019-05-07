# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Edit Forms", type: :request do
    let(:form) { build(:edit_form) }

    describe "GET edit_form" do
      let(:request_path) { "/waste_exemptions_engine/edit/#{form.token}" }

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"true\"" do
        before(:each) do
          WasteExemptionsEngine.configuration.edit_enabled = "true"
        end

        it "renders the appropriate template" do
          get request_path
          expect(response).to render_template("waste_exemptions_engine/edit_forms/new")
        end

        it "responds to the GET request with a 200 status code" do
          get request_path
          expect(response.code).to eq("200")
        end

        context "when the token is a registration reference" do
          let(:registration) { create(:registration, :complete) }

          let(:request_path) { "/waste_exemptions_engine/edit/#{registration.reference}" }

          it "renders the appropriate template" do
            get request_path
            expect(response).to render_template("waste_exemptions_engine/edit_forms/new")
          end

          it "responds to the GET request with a 200 status code" do
            get request_path
            expect(response.code).to eq("200")
          end

          it "loads the edit form for that registration" do
            get request_path
            expect(response.body).to include(registration.reference)
          end

          context "when the registration doesn't have an edit in progress" do
            it "creates a new EditRegistration for the registration" do
              expect { get request_path }.to change { EditRegistration.where(reference: registration.reference).count }.from(0).to(1)
            end
          end

          context "when the registration already has an edit in progress" do
            let(:edit_registration) { create(:edit_registration) }
            let(:request_path) { "/waste_exemptions_engine/edit/#{edit_registration.reference}" }

            it "does not create a new EditRegistration for the registration" do
              expect { get request_path }.to_not change { EditRegistration.where(reference: edit_registration.reference).count }.from(1)
            end
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
        end
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "/waste_exemptions_engine/edit/back/#{form.token}" }
      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "POST edit_form" do
      let(:request_path) { "/waste_exemptions_engine/edit/" }
      let(:request_body) { { edit_form: { token: form.token } } }

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"true\"" do
        before(:each) do
          WasteExemptionsEngine.configuration.edit_enabled = "true"
        end

        status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

        # A successful POST request redirects to the next form in the work flow. We have chosen to
        # differentiate 'good' rediection as 303 and 'bad' redirection as 302.
        it "responds to the POST request with a #{status_code} status code" do
          post request_path, request_body
          expect(response.code).to eq(status_code.to_s)
        end
      end

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is anything other than \"true\"" do
        before(:each) { WasteExemptionsEngine.configuration.edit_enabled = "false" }

        it "renders the error_404 template" do
          post request_path, request_body
          expect(response.location).to include("errors/404")
        end

        it "responds with a status of 404" do
          post request_path, request_body
          expect(response.code).to eq("404")
        end
      end
    end

    %w[location
       applicant_name
       applicant_phone
       applicant_email
       main_people
       registration_number
       operator_name
       operator_postcode
       contact_name
       contact_phone
       contact_email
       contact_postcode
       on_a_farm
       is_a_farmer
       site_grid_reference].each do |edit_action|
      describe "GET edit_#{edit_action}" do
        let(:request_path) { "/waste_exemptions_engine/edit/#{edit_action}/#{form.token}" }

        context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"true\"" do
          before(:each) do
            WasteExemptionsEngine.configuration.edit_enabled = "true"
          end

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
          before(:each) { WasteExemptionsEngine.configuration.edit_enabled = "false" }

          it "renders the error_404 template" do
            get request_path
            expect(response.location).to include("errors/404")
          end

          it "responds with a status of 404" do
            get request_path
            expect(response.code).to eq("404")
          end
        end
      end
    end
  end
end
