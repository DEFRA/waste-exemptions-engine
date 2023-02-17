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
        let(:transient_registration) { form.transient_registration }
        let(:registration) { transient_registration.registration }
        let(:excluded_exemptions) { transient_registration.excluded_exemptions }
        let(:original_exemptions) { registration.exemptions }
        let(:full_confirmation_email_service) { instance_double(DeregistrationConfirmationEmailService) }
        let(:partial_confirmation_email_service) { instance_double(RegistrationEditConfirmationEmailService) }

        before do
          allow(DeregistrationConfirmationEmailService).to receive(:new).and_return(full_confirmation_email_service)
          allow(full_confirmation_email_service).to receive(:run)
          allow(RegistrationEditConfirmationEmailService).to receive(:new).and_return(partial_confirmation_email_service)
          allow(partial_confirmation_email_service).to receive(:run)
        end

        context "with no exemptions removed" do
          before do
            transient_registration.exemptions = original_exemptions
            transient_registration.save!
          end

          it "redirects to the correct workflow step" do
            post request_path, params: valid_params

            expect(response).to redirect_to new_deregistration_complete_no_change_form_path(form.token)
          end
        end

        context "with a subset of exemptions removed" do
          before do
            transient_registration.exemptions.delete([original_exemptions.first, original_exemptions.last])
            transient_registration.save!
          end

          it "redirects to the correct workflow step" do
            post request_path, params: valid_params

            expect(response).to redirect_to new_deregistration_complete_partial_form_path(form.token)
          end
        end

        context "with all exemptions removed" do
          before do
            transient_registration.exemptions = []
            transient_registration.save!
          end

          it "redirects to the correct workflow step" do
            post request_path, params: valid_params

            expect(response).to redirect_to new_deregistration_complete_full_form_path(form.token)
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
