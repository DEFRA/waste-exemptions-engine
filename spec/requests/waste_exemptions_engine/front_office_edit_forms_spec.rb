# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Front Office Edit Forms" do
    let(:valid_edit_token) { SecureRandom.hex(22) }
    let(:edit_token) { valid_edit_token }
    let(:edit_token_created_at) { 1.hour.ago }
    let(:registration) { create(:registration, edit_token: valid_edit_token, edit_token_created_at:) }

    describe "GET /waste_exemptions_engine/edit_registration/edit_token" do

      let(:request_path) { validate_edit_token_path(edit_token:) }

      before do
        # force instantiation
        registration

        get request_path
      end

      context "when the token is invalid" do
        let(:edit_token) { "foo" }

        it "returns the expected invalid link response" do
          aggregate_failures do
            expect(response).to render_template("waste_exemptions_engine/front_office_edit_forms/invalid_edit_link")
            expect(response).to have_http_status(:not_found)
            expect(response.body).to have_valid_html
          end
        end
      end

      context "when the token has expired" do
        let(:edit_token_created_at) { 3.days.ago }

        it "returns the expected expired link response" do
          aggregate_failures do
            expect(response).to render_template("waste_exemptions_engine/front_office_edit_forms/edit_link_expired")
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to have_valid_html
          end
        end
      end

      context "when the token is valid" do

        context "when the page is loaded" do
          let(:token) { FrontOfficeEditRegistration.last.token }

          before do
            get request_path
            follow_redirect!
          end

          it "includes the expected edit links" do
            aggregate_failures do
              expect(response.body).to include edit_exemptions_front_office_edit_forms_path(token)
              expect(response.body).to include contact_name_front_office_edit_forms_path(token)
              expect(response.body).to include contact_phone_front_office_edit_forms_path(token)
              expect(response.body).to include contact_email_front_office_edit_forms_path(token)
            end
          end
        end
      end
    end

    describe "POST front_office_edit_form" do
      let(:request_path) { front_office_edit_forms_path(front_office_edit_registration.token) }

      before { post request_path }

      context "when no changes have been made" do
        let(:front_office_edit_registration) { create(:front_office_edit_registration) }

        it { expect(response).to render_template("waste_exemptions_engine/front_office_edit_forms/declaration") }
      end

      context "when changes have been made" do
        let(:front_office_edit_registration) { create(:front_office_edit_registration, :modified) }

        it { expect(response).to render_template("waste_exemptions_engine/front_office_edit_forms/declaration") }
      end
    end
  end
end
