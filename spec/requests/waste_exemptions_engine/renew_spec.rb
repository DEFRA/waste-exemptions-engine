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
      let(:companies_house_service) { instance_double(DefraRubyCompaniesHouse) }

      before do
        allow(DefraRubyCompaniesHouse).to receive(:new).and_return(companies_house_service)
        allow(companies_house_service).to receive_messages(
          load_company: true,
          company_name: company_name,
          registered_office_address_lines: company_address
        )
      end

      context "with a valid renew token" do
        let(:token) { registration.renew_token }

        context "when the business type is a company or llp" do
          context "when in renewal window" do
            it "redirects to the check registered name and address form" do
              get request_path

              expect(response).to redirect_to(new_check_registered_name_and_address_form_path(token: transient_registration_token))
            end

            it "creates a new RenewingRegistration" do
              expect { get request_path }.to change(RenewingRegistration, :count).by(1)
            end
          end

          context "when not in renewal window" do
            let(:registration) { create(:registration, :complete) }

            it "redirects to the edit exemptions form" do
              get request_path

              expect(response).to redirect_to(edit_exemptions_forms_path(token: transient_registration_token))
            end

            it "creates a new RenewingRegistration" do
              expect { get request_path }.to change(RenewingRegistration, :count).by(1)
            end
          end
        end

        context "when the business type is not a company or llp" do
          before do
            registration.update_attribute(:business_type, "soleTrader")
          end

          context "when in renewal window" do
            it "redirects to the renewal start form" do
              get request_path

              expect(response).to redirect_to(new_renewal_start_form_path(token: transient_registration_token))
            end

            it "creates a new RenewingRegistration" do
              expect { get request_path }.to change(RenewingRegistration, :count).by(1)
            end
          end

          context "when not in renewal window" do
            let(:registration) { create(:registration, :complete) }

            it "redirects to the edit exemptions form" do
              get request_path

              expect(response).to redirect_to(edit_exemptions_forms_path(token: transient_registration_token))
            end

            it "creates a new RenewingRegistration" do
              expect { get request_path }.to change(RenewingRegistration, :count).by(1)
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

        it "responds with a 200 status", :vcr do
          get request_path

          expect(response).to have_http_status(:ok)
        end

        it "renders the appropriate template", :vcr do
          get request_path

          expect(response).to render_template("waste_exemptions_engine/renews/already_renewed")
        end

        it "returns W3C valid HTML content", :vcr do
          get request_path

          expect(response.body).to have_valid_html
        end
      end

      context "when a registration is past the renewal window" do
        let(:registration) { create(:registration, :complete, :past_renewal_window) }
        let(:token) { registration.renew_token }

        it "responds with a 200 status", :vcr do
          get request_path

          expect(response).to have_http_status(:ok)
        end

        it "renders the appropriate template", :vcr do
          get request_path

          expect(response).to render_template("waste_exemptions_engine/renews/past_renewal_window")
        end

        it "returns W3C valid HTML content", :vcr do
          get request_path

          expect(response.body).to have_valid_html
        end
      end

      context "when a token is invalid" do
        let(:token) { "FooBarBaz" }

        it "returns a 404 status", :vcr do
          get request_path

          expect(response).to have_http_status(:not_found)
        end

        it "renders the correct template", :vcr do
          get request_path

          expect(response).to render_template("waste_exemptions_engine/renews/invalid_magic_link")
        end

        it "returns W3C valid HTML content", :vcr do
          get request_path

          expect(response.body).to have_valid_html
        end
      end

      context "when registration is deregistered" do
        let(:registration) { create(:registration, :with_ceased_exemptions) }
        let(:token) { registration.renew_token }

        it "responds with a 200 status", :vcr do
          get request_path

          expect(response).to have_http_status(:ok)
        end

        it "renders the appropriate template", :vcr do
          get request_path

          expect(response).to render_template("waste_exemptions_engine/renews/deregistered")
        end

        it "returns W3C valid HTML content", :vcr do
          get request_path

          expect(response.body).to have_valid_html
        end
      end
    end
  end
end
