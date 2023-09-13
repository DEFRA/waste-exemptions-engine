# frozen_string_literal: true

require "rails_helper"
require "defra_ruby_companies_house"

module WasteExemptionsEngine
  RSpec.describe "Renew" do
    describe "GET renew/:token" do
      let(:registration) { create(:registration, :complete, :in_renewal_window) }
      let(:request_path) { "/waste_exemptions_engine/renew/#{token}" }
      let(:company_name) { Faker::Company.name }
      let(:company_address) { ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"] }
      let(:transient_registration_token) { RenewingRegistration.first.token }

      # rubocop:disable RSpec/AnyInstance
      before do
        allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:load_company).and_return(true)
        allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:company_name).and_return(company_name)
        allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:registered_office_address_lines).and_return(company_address)
      end
      # rubocop:enable RSpec/AnyInstance

      context "with a valid renew token" do
        let(:token) { registration.renew_token }

        context "when the business type is a company or llp" do
          context "when in renewal window" do
            it "redirects to the check registered name and address form, creates a new RenewingRegistration and returns a 303 status code" do
              expected_count = RenewingRegistration.count + 1

              get request_path

              expect(response).to redirect_to(new_check_registered_name_and_address_form_path(token: transient_registration_token))
              expect(RenewingRegistration.count).to eq(expected_count)
            end
          end

          context "when not in renewal window" do
            let(:registration) { create(:registration, :complete) }

            it "redirects to the edit exemptions form, creates a new RenewingRegistration and returns a 303 status code" do
              expected_count = RenewingRegistration.count + 1

              get request_path

              expect(response).to redirect_to(edit_exemptions_forms_path(token: transient_registration_token))
              expect(RenewingRegistration.count).to eq(expected_count)
            end
          end
        end

        context "when the business type is not a company or llp" do
          before do
            registration.update_attribute(:business_type, "soleTrader")
          end

          context "when in renewal window" do
            it "redirects to the renewal start form, creates a new RenewingRegistration and returns a 303 status code" do
              expected_count = RenewingRegistration.count + 1

              get request_path

              expect(response).to redirect_to(new_renewal_start_form_path(token: transient_registration_token))
              expect(RenewingRegistration.count).to eq(expected_count)
            end
          end

          context "when not in renewal window" do
            let(:registration) { create(:registration, :complete) }

            it "redirects to the edit exemptions form, creates a new RenewingRegistration and returns a 303 status code" do
              expected_count = RenewingRegistration.count + 1

              get request_path

              expect(response).to redirect_to(edit_exemptions_forms_path(token: transient_registration_token))
              expect(RenewingRegistration.count).to eq(expected_count)
            end
          end
        end

        context "when a renewal was left in progress" do
          context "when the business type is a company" do
            context "when in renewal window" do
              it "redirects to the correct flow state page" do
                # Request the page once so we generate a valid renewing registration
                get request_path

                # Update the workflow of the transient registration
                renewing_registration = RenewingRegistration.last
                renewing_registration.update workflow_state: "location_form"

                get request_path
                expect(response).to redirect_to(new_check_registered_name_and_address_form_path(token: transient_registration_token))
              end
            end

            context "when not in renewal window" do
              let(:registration) { create(:registration, :complete) }

              it "redirects to the correct flow state page" do
                # Request the page once so we generate a valid renewing registration
                get request_path

                # Update the workflow of the transient registration
                renewing_registration = RenewingRegistration.last
                renewing_registration.update workflow_state: "location_form"

                get request_path
                expect(response).to redirect_to(edit_exemptions_forms_path(token: transient_registration_token))
              end
            end
          end

          context "when the business type is not a company or llp" do
            before { registration.update_attribute(:business_type, "soleTrader") }

            context "when in renewal window" do
              it "redirects to the correct flow state page" do
                # Request the page once so we generate a valid renewing registration
                get request_path

                # Update the workflow of the transient registration
                renewing_registration = RenewingRegistration.last
                renewing_registration.update workflow_state: "location_form"

                get request_path
                expect(response).to redirect_to(new_renewal_start_form_path(token: transient_registration_token))
              end
            end

            context "when not in renewal window" do
              let(:registration) { create(:registration, :complete) }

              it "redirects to the correct flow state page" do
                # Request the page once so we generate a valid renewing registration
                get request_path

                # Update the workflow of the transient registration
                renewing_registration = RenewingRegistration.last
                renewing_registration.update workflow_state: "location_form"

                get request_path
                expect(response).to redirect_to(edit_exemptions_forms_path(token: transient_registration_token))
              end
            end
          end
        end
      end

      context "when a token has already been used" do
        let(:token) { registration.renew_token }

        before do
          create(:registration, referring_registration_id: registration.id)
        end

        it "respond with a 200 status, renders the appropriate template and returns W3C valid HTML content", :vcr do
          get request_path

          expect(response).to have_http_status(:ok)
          expect(response).to render_template("waste_exemptions_engine/renews/already_renewed")
          expect(response.body).to have_valid_html
        end
      end

      context "when a registration is past the renewal window" do
        let(:registration) { create(:registration, :complete, :past_renewal_window) }
        let(:token) { registration.renew_token }

        it "respond with a 200 status, renders the appropriate template and returns W3C valid HTML content", :vcr do
          get request_path

          expect(response).to have_http_status(:ok)
          expect(response).to render_template("waste_exemptions_engine/renews/past_renewal_window")
          expect(response.body).to have_valid_html
        end
      end

      context "when a token is invalid" do
        let(:token) { "FooBarBaz" }

        it "returns a 404 status, renders the correct template and returns W3C valid HTML content", :vcr do
          get request_path

          expect(response).to have_http_status(:not_found)
          expect(response).to render_template("waste_exemptions_engine/renews/invalid_magic_link")
          expect(response.body).to have_valid_html
        end
      end

      context "when registration is deregistered" do
        let(:registration) { create(:registration, :with_ceased_exemptions) }
        let(:token) { registration.renew_token }

        it "respond with a 200 status, renders the appropriate template and returns W3C valid HTML content", :vcr do
          get request_path

          expect(response).to have_http_status(:ok)
          expect(response).to render_template("waste_exemptions_engine/renews/deregistered")
          expect(response.body).to have_valid_html
        end
      end
    end
  end
end
