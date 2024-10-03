# frozen_string_literal: true

module WasteExemptionsEngine
  class CertificatesController < ::WasteExemptionsEngine::ApplicationController
    before_action :find_resource
    before_action :ensure_valid_email, only: %i[show pdf]
    before_action :ensure_valid_token, only: %i[confirm_email show pdf]
    before_action :confirm_email_form, only: %i[confirm_email process_email]

    def confirm_email
      # to render the confirm_email view, with registration from before_action
    end

    def process_email
      email = params[:confirm_email_form][:email]
      unless valid_email?(email)
        @confirm_email_form.errors.add(:email, I18n.t(".waste_exemptions_engine.certificates.process_email.error"))
        render :confirm_email and return
      end

      session[:valid_email] = email
      redirect_to certificate_path(@resource.reference,
                                   token: @resource.view_certificate_token)
    end

    def show
      @presenter = WasteExemptionsEngine::CertificatePresenter.new(@resource)
    end

    def pdf
      @presenter = WasteExemptionsEngine::CertificatePresenter.new(@resource)
      render  pdf: @resource.reference,
              layout: false,
              page_size: "A4",
              margin: { top: "10mm", bottom: "10mm", left: "10mm", right: "10mm" },
              print_media_type: true,
              template: "waste_exemptions_engine/pdfs/certificate",
              enable_local_file_access: true
    end

    private

    def confirm_email_form
      @confirm_email_form ||= WasteExemptionsEngine::ConfirmEmailForm.new
    end

    def ensure_valid_email
      return if valid_email?(session[:valid_email])

      redirect_to certificate_confirm_email_path(@resource.reference, token: params[:token])
    end

    def valid_email?(email)
      [@resource.contact_email, @resource.applicant_email].compact.map(&:downcase).include?(email.to_s.strip.downcase)
    end

    def ensure_valid_token
      return if token_valid_and_matches?

      flash[:error] = I18n.t(".waste_exemptions_engine.certificates.errors.token")
      redirect_back(fallback_location: new_start_form_path) and return
    end

    def token_valid_and_matches?
      return false unless params[:token].present? && @resource.view_certificate_token_valid?

      params[:token] == @resource.view_certificate_token
    end

    def find_resource
      @resource = WasteExemptionsEngine::Registration.find_by(reference: params[:registration_reference])
    end

  end
end
