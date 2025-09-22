# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Registrations" do
    let(:registration) { create(:registration, :complete, contact_email: "contact@example.com") }

    shared_examples "renders invalid page" do
      it "renders invalid page" do
        get completed_registration_path(registration_reference, email: email)

        aggregate_failures do
          expect(response.media_type).to eq("text/html")
          expect(response).to redirect_to(page_path("invalid"))
        end
      end
    end

    shared_examples "renders registration complete form" do
      it "renders registration_complete_forms/new template" do
        get completed_registration_path(registration_reference, email: email)

        aggregate_failures do
          expect(response.media_type).to eq("text/html")
          expect(response).to have_http_status(:ok)
          expect(response).to render_template("waste_exemptions_engine/registration_complete_forms/new")
        end
      end
    end

    describe "GET complete" do
      context "with valid registration reference" do
        let(:registration_reference) { registration.reference }

        context "with valid applicant email address" do
          let(:email) { registration.applicant_email }

          it_behaves_like "renders registration complete form"
        end

        context "with valid contact email address" do
          let(:email) { registration.contact_email }

          it_behaves_like "renders registration complete form"
        end

        context "with invalid email address" do
          let(:email) { "INVALID" }

          it_behaves_like "renders invalid page"
        end
      end

      context "with invalid registration reference" do
        let(:registration_reference) { "INVALID" }

        context "with valid applicant email address" do
          let(:email) { registration.applicant_email }

          it_behaves_like "renders invalid page"
        end

        context "with valid contact email address" do
          let(:email) { registration.contact_email }

          it_behaves_like "renders invalid page"
        end

        context "with invalid email address" do
          let(:email) { "INVALID" }

          it_behaves_like "renders invalid page"
        end
      end
    end

  end
end
