# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Certificates" do
    let(:registration) do
      create(:registration, :complete, contact_email: "contact@example.com")
        .tap(&:generate_view_certificate_token!)
    end
    let(:token) { registration.view_certificate_token }

    let(:valid_email) { registration.contact_email }
    let(:invalid_email) { "invalid@example.com" }
    let(:base_path) { "/waste_exemptions_engine/#{registration.reference}/certificate" }
    let(:valid_email_uppercase) { valid_email.upcase }
    let(:valid_email_mixed_case) { "ConTact@ExAmple.CoM" }
    let(:valid_email_params) { { confirm_email_form: { email: valid_email } } }
    let(:invalid_email_params) { { confirm_email_form: { email: invalid_email } } }
    let(:form) { build(:confirm_email_form) }

    describe "POST process_email" do
      context "with valid email" do
        it "sets the valid email in session and redirects to the certificate page" do
          post process_email_path, params: { confirm_email_form: { email: valid_email } }
          expect(response).to redirect_to("#{base_path}?token=#{token}")
        end

        it "redirects to the certificate page with uppercase email" do
          post process_email_path, params: { confirm_email_form: { email: valid_email_uppercase } }
          expect(response).to redirect_to("#{base_path}?token=#{token}")
        end

        it "redirects to the certificate page with mixed case email" do
          post process_email_path, params: { confirm_email_form: { email: valid_email_mixed_case } }
          expect(response).to redirect_to("#{base_path}?token=#{token}")
        end
      end

      context "with invalid email" do
        it "does not set the email in session and renders the confirmation page with an error" do
          allow(WasteExemptionsEngine::ConfirmEmailForm).to receive(:new).and_return(form)

          post process_email_path, params: invalid_email_params

          aggregate_failures do
            expect(form.errors[:email].count).to eq(1)
            expect(response).to render_template(:confirm_email)
          end
        end
      end
    end

    describe "GET show" do
      context "with valid email in session and valid token" do
        subject(:get_certificate) { get "#{base_path}?token=#{token}" }

        before { post process_email_path, params: valid_email_params }

        it "renders the HTML certificate" do
          get_certificate

          aggregate_failures do
            expect(response.media_type).to eq("text/html")
            expect(response).to have_http_status(:ok)
          end
        end
      end

      context "with valid email in session but invalid token" do
        before { post process_email_path, params: valid_email_params }

        it "redirects due to invalid token" do
          get "#{base_path}?token=invalidtoken"

          aggregate_failures do
            expect(response).to redirect_to(new_start_form_path)
            expect(flash[:error]).to eq("There is a problem with the link you have used to access this page. Please contact the Environment Agency for help.")
          end
        end
      end

      context "without valid email in session or token" do
        before { post process_email_path, params: invalid_email_params }

        it "redirects to the email confirmation page" do
          get base_path

          aggregate_failures do
            expect(response).to redirect_to(certificate_confirm_email_path(registration.reference))
            expect(response).to have_http_status(:found)
          end
        end
      end

      context "without valid email in session but with valid token" do
        before { post process_email_path, params: invalid_email_params }

        it "redirects to the email confirmation page" do
          get "#{base_path}?token=#{token}"

          aggregate_failures do
            expect(response).to redirect_to(certificate_confirm_email_path(registration.reference, token: token))
            expect(response).to have_http_status(:found)
          end
        end
      end
    end

    describe "GET pdf" do
      subject(:get_certificate) { get "#{base_path}?token=#{token}" }

      let(:base_path) { "/waste_exemptions_engine/#{registration.reference}/pdf_certificate" }

      context "with valid email in session and valid token" do
        before { post process_email_path, params: valid_email_params }

        it "renders the page" do
          get_certificate

          expect(response).to have_http_status(:ok)
        end
      end

      context "with valid email in session but invalid token" do
        before { post process_email_path, params: valid_email_params }

        it "redirects due to invalid token" do
          get "#{base_path}?token=invalidtoken"

          aggregate_failures do
            expect(response).to redirect_to(new_start_form_path)
            expect(flash[:error]).to eq("There is a problem with the link you have used to access this page. Please contact the Environment Agency for help.")
          end
        end
      end

      context "without valid email in session" do
        before { post process_email_path, params: invalid_email_params }

        it "redirects to the email confirmation page" do
          get "#{base_path}.pdf"

          aggregate_failures do
            expect(response).to redirect_to(certificate_confirm_email_path(registration.reference))
            expect(response).to have_http_status(:found)
          end
        end
      end
    end

    describe "GET confirm_email" do
      context "with a valid token" do
        it "renders the confirm email page" do
          get certificate_confirm_email_path(registration.reference, token: token)
          expect(response).to render_template(:confirm_email)
        end
      end

      context "with an invalid token" do
        before { post process_email_path, params: valid_email_params }

        it "redirects due to invalid token" do
          get certificate_confirm_email_path(registration.reference, token: "invalidtoken")

          aggregate_failures do
            expect(response).to redirect_to(new_start_form_path)
            expect(flash[:error]).to eq("There is a problem with the link you have used to access this page. Please contact the Environment Agency for help.")
          end
        end
      end
    end

    def process_email_path
      certificate_process_email_path(registration.reference)
    end
  end
end
