# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Front Office Edit Forms" do
    let(:edit_token) { SecureRandom.hex(22) }
    let(:edit_token_created_at) { 1.hour.ago }
    let(:registration) { create(:registration, edit_token:, edit_token_created_at:) }

    describe "GET /waste_exemptions_engine/edit_registration/edit_token" do

      let(:request_path) { validate_edit_token_path(edit_token:) }

      before do
        # force instantiation
        registration

        get request_path
      end

      context "when the token is invalid" do
        let(:edit_token) { "foo" }

        it { expect(response).to render_template("waste_exemptions_engine/front_office_edit_forms/invalid_edit_link") }
        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.body).to have_valid_html }
      end

      context "when the token has expired" do
        let(:edit_token_created_at) { 3.days.ago }

        it { expect(response).to render_template("waste_exemptions_engine/front_office_edit_forms/edit_link_expired") }
        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(response.body).to have_valid_html }
      end

      context "when the token is valid" do

        context "when the page is loaded" do
          let(:token) { FrontOfficeEditRegistration.last.token }

          before { get request_path }

          it { expect(response.body).to include edit_exemptions_front_office_edit_forms_path(token) }
          it { expect(response.body).to include contact_name_front_office_edit_forms_path(token) }
          it { expect(response.body).to include contact_phone_front_office_edit_forms_path(token) }
          it { expect(response.body).to include contact_email_front_office_edit_forms_path(token) }
        end

        context "when the registration doesn't have an edit in progress" do
          it "creates a new FrontOfficeEditRegistration for the registration" do
            expect { get request_path }.to change { FrontOfficeEditRegistration.where(reference: registration.reference).count }.from(0).to(1)
          end
        end

        context "when the registration already has an edit in progress" do
          before { create(:front_office_edit_registration, reference: registration.reference) }

          it "does not create a new FrontOfficeEditRegistration for the registration" do
            expect { get request_path }.not_to change { FrontOfficeEditRegistration.where(reference: registration.reference).count }.from(1)
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
