# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Front Office Edit Forms" do
    let(:valid_edit_token) { SecureRandom.hex(22) }
    let(:edit_token) { valid_edit_token }
    let(:edit_token_created_at) { 1.hour.ago }
    let(:registration) { create(:registration, edit_token: valid_edit_token, edit_token_created_at:) }
    let(:transient_registration_token) { FrontOfficeEditRegistration.last.token }

    describe "GET /waste_exemptions_engine/edit_registration/edit_token" do

      let(:request_path) { validate_edit_token_path(edit_token:) }

      before do
        # force instantiation
        registration

        get request_path
      end

      context "when the edit_token is invalid" do
        let(:edit_token) { "foo/bar/baz.txt" }

        it "returns the expected invalid link response" do
          aggregate_failures do
            expect(response).to render_template("waste_exemptions_engine/front_office_edit_forms/invalid_edit_link")
            expect(response).to have_http_status(:not_found)
            expect(response.body).to have_valid_html
          end
        end
      end

      context "when the edit token has expired" do
        let(:edit_token_created_at) { 3.days.ago }

        it "returns the expected expired link response" do
          aggregate_failures do
            expect(response).to render_template("waste_exemptions_engine/front_office_edit_forms/edit_link_expired")
            expect(response).to have_http_status(:not_found)
            expect(response.body).to have_valid_html
          end
        end
      end

      context "when the edit token is valid" do

        before do
          get request_path
          follow_redirect!
        end

        context "when the registration is single-site" do
          let(:exemption_one) { create(:exemption, code: "SS1", summary: "Single site summary one") }
          let(:exemption_two) { create(:exemption, code: "SS2", summary: "Single site summary two") }
          let(:registration) do
            create(:registration,
                   edit_token: valid_edit_token,
                   edit_token_created_at:).tap do |registration|
              create(:registration_exemption, registration:, exemption: exemption_one)
              create(:registration_exemption, registration:, exemption: exemption_two)
            end
          end

          it "the page includes the expected edit links including exemptions" do
            aggregate_failures do
              expect(response.body).to include edit_exemptions_front_office_edit_forms_path(transient_registration_token)
              expect(response.body).to include contact_name_front_office_edit_forms_path(transient_registration_token)
              expect(response.body).to include contact_phone_front_office_edit_forms_path(transient_registration_token)
              expect(response.body).to include contact_email_front_office_edit_forms_path(transient_registration_token)
              expect(response.body).to include contact_postcode_front_office_edit_forms_path(transient_registration_token)
            end
          end

          it "keeps the existing exemptions display" do
            aggregate_failures do
              expect(response.body).to include "SS1, SS2"
              expect(response.body).not_to include "Single site summary one"
              expect(response.body).not_to include "Locations:"
              expect(response.body).not_to include "Contact us if you need to deregister exemptions"
            end
          end
        end

        context "when the registration is multi-site" do
          let(:duplicate_exemption) { create(:exemption, code: "MS9", summary: "Repeated multisite summary") }
          let(:registration) do
            create(:registration,
                   :complete,
                   :multisite,
                   edit_token: valid_edit_token,
                   edit_token_created_at:).tap do |registration|
              create(:registration_exemption,
                     registration:,
                     exemption: duplicate_exemption,
                     address: registration.site_addresses.first)
              create(:registration_exemption,
                     registration:,
                     exemption: duplicate_exemption,
                     address: registration.site_addresses.second)
            end
          end

          before do
            allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
          end

          it "the page does not include the exemptions edit link" do
            expect(response.body).not_to include edit_exemptions_front_office_edit_forms_path(transient_registration_token)
          end

          it "the page includes the other expected edit links" do
            aggregate_failures do
              expect(response.body).to include contact_name_front_office_edit_forms_path(transient_registration_token)
              expect(response.body).to include contact_phone_front_office_edit_forms_path(transient_registration_token)
              expect(response.body).to include contact_email_front_office_edit_forms_path(transient_registration_token)
              expect(response.body).to include contact_postcode_front_office_edit_forms_path(transient_registration_token)
            end
          end

          it "shows each exemption once" do
            expect(response.body.scan("MS9 Repeated multisite summary").size).to eq(1)
          end
        end
      end
    end

    describe "POST front_office_edit_form" do
      let(:request_path) { front_office_edit_forms_path(front_office_edit_registration.token) }

      before { post request_path }

      context "when no changes have been made" do
        let(:front_office_edit_registration) { create(:front_office_edit_registration) }

        it { expect(response).to redirect_to new_front_office_edit_declaration_form_path(front_office_edit_registration.token) }
      end

      context "when changes have been made" do
        let(:front_office_edit_registration) { create(:front_office_edit_registration, :modified) }

        it { expect(response).to redirect_to new_front_office_edit_declaration_form_path(front_office_edit_registration.token) }
      end
    end
  end
end
