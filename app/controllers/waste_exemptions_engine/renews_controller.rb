# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewsController < ApplicationController
    before_action :validate_authenticity_of_renew_token

    def new
      @renewal = RenewalStartService.run(registration: registration)
    end

    private

    def validate_authenticity_of_renew_token
      result = ValidateAuthenticityOfRenewTokenService.run(token: params[:token])

      return head(:forbidden) unless result && registration.present?
    end

    def registration
      @_registration ||= Registration.find_by(renew_token: params[:token])
    end
  end
end
