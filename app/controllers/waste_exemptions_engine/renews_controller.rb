# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewsController < ::WasteExemptionsEngine::ApplicationController
    include CanRedirectFormToCorrectPath

    before_action :validate_renew_token

    def new
      @transient_registration = RenewalStartService.run(registration: registration)
      @transient_registration.workflow_state =
        if @transient_registration.company_no_required?
          :check_registered_name_and_address_form
        else
          :renewal_start_form
        end
      redirect_to_correct_form
    end

    private

    def validate_renew_token
      return render(:invalid_magic_link, status: 404) unless registration.present?

      return render(:already_renewed) if registration.already_renewed?
      return render(:past_renewal_window) if registration.past_renewal_window?
    end

    def registration
      @registration ||= Registration.find_by(renew_token: params[:token])
    end
  end
end
