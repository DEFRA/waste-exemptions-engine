# frozen_string_literal: true

module WasteExemptionsEngine
  module CanHaveViewCertificateToken
    extend ActiveSupport::Concern
    include CanGenerateAndValidateToken

    included do
      def generate_view_certificate_token!
        generate_token(:view_certificate_token, :view_certificate_token_created_at)
      end

      def view_certificate_token_valid?
        # view certificate tokens currently have no validity period
        view_certificate_token.present?
      end
    end
  end
end
