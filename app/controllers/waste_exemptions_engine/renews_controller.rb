# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewsController < ApplicationController
    include CanRedirectFormToCorrectPath

    before_action :validate_authenticity_of_renew_token

    def new
      @transient_registration = RenewalStartService.run(registration: registration)

      redirect_to_correct_form
    end

    private

    def validate_authenticity_of_renew_token
      result = ValidateAuthenticityOfRenewTokenService.run(token: params[:token])

      redirect_to(error_path(status: 403)) unless result && registration.present?
    end

    def registration
      @_registration ||= Registration.find_by(renew_token: params[:token])
    end
  end
end
