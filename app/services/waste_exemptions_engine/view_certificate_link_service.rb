# frozen_string_literal: true

module WasteExemptionsEngine
  class ViewCertificateLinkService < BaseService
    def run(registration:, renew_token: false)
      @registration = registration
      @renew_token = renew_token

      [
        Rails.configuration.front_office_url,
        "/",
        @registration.reference,
        "/certificate?token=",
        view_certificate_token
      ].join
    end

    private

    attr_reader :registration, :renew_token

    def view_certificate_token
      if renew_token || registration.view_certificate_token.blank?
        registration.generate_view_certificate_token!
      else
        registration.view_certificate_token
      end
    end
  end
end
