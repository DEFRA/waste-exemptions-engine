# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Sites Forms" do
    before do
      allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
    end

    let(:form) { build(:sites_form) }

    describe "GET sites_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/sites" }

      it "renders the appropriate template", :vcr do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/sites_forms/new")
      end

      it "returns a 200 status code", :vcr do
        get request_path
        expect(response).to have_http_status(:ok)
      end

      it "returns W3C valid HTML content", :vcr, :ignore_hidden_autocomplete do
        get request_path
        expect(response.body).to have_valid_html
      end

      context "with page parameter" do
        it "returns a success response" do
          get request_path, params: { page: 2 }
          expect(response).to have_http_status(:ok)
        end
      end

      context "when there are multiple pages of sites" do
        before do
          allow(ENV).to receive(:fetch).and_call_original
          allow(ENV).to receive(:fetch).with("MULTISITE_PAGINATION_SIZE", 20).and_return("2")

          create(:transient_address, :site_using_grid_reference,
                 transient_registration: form.transient_registration,
                 description: "Site 1 description",
                 grid_reference: "ST 11111 11111")
          create(:transient_address, :site_using_grid_reference,
                 transient_registration: form.transient_registration,
                 description: "Site 2 description",
                 grid_reference: "ST 22222 22222")
          create(:transient_address, :site_using_grid_reference,
                 transient_registration: form.transient_registration,
                 description: "Site 3 description",
                 grid_reference: "ST 33333 33333")
        end

        it "defaults to the last numbered page when no page is provided" do
          get request_path

          aggregate_failures do
            expect(response.body).to include("Site 3 description")
            expect(response.body).not_to include("Site 1 description")
          end
        end
      end
    end

    describe "POST sites_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/sites" }
      let(:request_body) { { sites_form: { token: form.token } } }

      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      it "responds to the POST request with a #{status_code} status code" do
        post request_path, params: request_body
        expect(response.code).to eq(status_code.to_s)
      end

      it "redirects to the on a farm form" do
        post request_path, params: request_body
        expect(response).to redirect_to(on_a_farm_forms_path(form.token))
      end

      context "with page parameter" do
        it "redirects to the next step" do
          post request_path, params: request_body.merge(page: 2)
          expect(response).to have_http_status(:see_other)
        end
      end
    end

    context "when on Sites page during Check Your Answers flow - new registration" do
      let(:sites_form) { build(:check_your_answers_sites_form) }

      it "continues through multisite workflow when submitted" do
        post "/waste_exemptions_engine/#{sites_form.token}/sites",
             params: { sites_form: { token: sites_form.token } }

        expect(response).to redirect_to(exemptions_summary_forms_path(sites_form.token))
      end
    end

    describe "DELETE remove_site" do
      let(:transient_registration) { form.transient_registration }
      let!(:site_address) { create(:transient_address, transient_registration: transient_registration, address_type: "site") }
      let(:request_path) { remove_site_sites_forms_path(form.token, site_id: site_address.id) }

      context "when site exists" do
        it "removes the site and redirects back to sites page" do
          aggregate_failures do
            expect do
              delete request_path
            end.to change { transient_registration.addresses.where(address_type: "site").count }.by(-1)

            expect(response).to redirect_to(new_sites_form_path(form.token, page: nil))
          end
        end

        it "removes the correct site" do
          delete request_path
          expect(transient_registration.addresses.where(id: site_address.id)).to be_empty
        end

        context "with page parameter" do
          it "redirects without a page parameter so the last page is shown" do
            delete request_path, params: { page: 2 }
            expect(response).to redirect_to(new_sites_form_path(form.token))
          end
        end

        context "when removing a site changes the last page" do
          let!(:site_address) do
            create(:transient_address, :site_using_grid_reference,
                   transient_registration: transient_registration,
                   description: "Site 1 description",
                   grid_reference: "ST 11111 11111")
          end
          let!(:site_2) do
            create(:transient_address, :site_using_grid_reference,
                   transient_registration: transient_registration,
                   description: "Site 2 description",
                   grid_reference: "ST 22222 22222")
          end
          let!(:site_3) do
            create(:transient_address, :site_using_grid_reference,
                   transient_registration: transient_registration,
                   description: "Site 3 description",
                   grid_reference: "ST 33333 33333")
          end
          let!(:site_4) do
            create(:transient_address, :site_using_grid_reference,
                   transient_registration: transient_registration,
                   description: "Site 4 description",
                   grid_reference: "ST 44444 44444")
          end
          let!(:site_5) do
            create(:transient_address, :site_using_grid_reference,
                   transient_registration: transient_registration,
                   description: "Site 5 description",
                   grid_reference: "ST 55555 55555")
          end
          let(:request_path) { remove_site_sites_forms_path(form.token, site_id: site_address.id) }

          before do
            allow(ENV).to receive(:fetch).and_call_original
            allow(ENV).to receive(:fetch).with("MULTISITE_PAGINATION_SIZE", 20).and_return("2")
          end

          it "shows the final numbered page after redirecting" do
            delete request_path, params: { page: 3 }
            follow_redirect!

            aggregate_failures do
              expect(response.body).to include("Site 5 description")
              expect(response.body).not_to include("Site 2 description")
            end
          end
        end
      end

      context "when site does not exist" do
        let(:invalid_site_id) { 99_999 }
        let(:invalid_request_path) { remove_site_sites_forms_path(form.token, site_id: invalid_site_id) }

        it "redirects back to sites page with error" do
          delete invalid_request_path
          expect(response).to redirect_to(new_sites_form_path(form.token, page: nil))
        end

        it "does not remove any sites" do
          expect do
            delete invalid_request_path
          end.not_to change { transient_registration.addresses.where(address_type: "site").count }
        end
      end

      context "when site belongs to different registration" do
        let(:other_registration) { create(:new_charged_registration) }
        let!(:other_site) { create(:transient_address, address_type: "site", transient_registration: other_registration) }
        let(:other_site_request_path) { remove_site_sites_forms_path(form.token, site_id: other_site.id) }

        it "does not remove the site from other registration" do
          expect do
            delete other_site_request_path
          end.not_to change { other_registration.addresses.where(address_type: "site").count }
        end

        it "redirects back to sites page" do
          delete other_site_request_path
          expect(response).to redirect_to(new_sites_form_path(form.token, page: nil))
        end
      end

      context "when token is invalid" do
        let(:invalid_token) { "invalid_token" }
        let(:invalid_token_path) { remove_site_sites_forms_path(invalid_token, site_id: site_address.id) }

        it "redirects to start page with the token" do
          delete invalid_token_path
          aggregate_failures do
            expect(response).to have_http_status(:redirect)
            expect(response.location).to include("start")
          end
        end
      end
    end
  end
end
