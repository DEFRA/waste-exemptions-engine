# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Edit Complete Forms" do
    let(:form) { build(:back_office_edit_complete_form) }
    let(:edit_enabled) { "true" }

    before do
      WasteExemptionsEngine.configuration.edit_enabled = edit_enabled
    end

    describe "GET back_office_edit_complete_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/edit-complete" }

      it "renders the appropriate template, returns a 200 status code and W3C valid HTML content", :vcr do
        get request_path

        aggregate_failures do
          expect(response).to render_template("waste_exemptions_engine/back_office_edit_complete_forms/new")
          expect(response).to have_http_status(:ok)
          expect(response.body).to have_valid_html
        end
      end

      context "when the host application has a current_user" do
        # rubocop:disable RSpec/VerifiedDoubleReference
        let(:current_user) { instance_double("User", email: "user@example.com") }
        # rubocop:enable RSpec/VerifiedDoubleReference
        let(:controller_instance) { BackOfficeEditCompleteFormsController.new }

        before do
          allow(WasteExemptionsEngine.configuration).to receive(:use_current_user_for_whodunnit).and_return(true)
          allow(BackOfficeEditCompleteFormsController).to receive(:new).and_return(controller_instance)
          allow(controller_instance).to receive(:current_user).and_return(current_user)
          allow(controller_instance).to receive(:dispatch).and_call_original
          allow(current_user).to receive(:id).and_return(1)
        end

        it "assigns the correct whodunnit to the registration version", :versioning do
          get request_path

          registration = WasteExemptionsEngine::Registration.where(reference: form.transient_registration.reference).first
          expect(registration.reload.versions.last.whodunnit).to eq(current_user.id.to_s)
        end
      end

      context "when the host application does not have a current_user" do
        it "assigns the correct whodunnit to the registration version", :versioning do
          registration = form.transient_registration.registration

          get request_path

          expect(registration.reload.versions.last.whodunnit).to eq("public user")
        end
      end

      context "when the token is not a valid registration reference" do
        let(:request_path) { "/waste_exemptions_engine/edit/WEX987654" }

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
      let(:request_path) { "/waste_exemptions_engine/edit-complete/#{form.token}/back" }

      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    include_examples "unable to POST form", :back_office_edit_complete_form, "/edit-complete"
  end
end
