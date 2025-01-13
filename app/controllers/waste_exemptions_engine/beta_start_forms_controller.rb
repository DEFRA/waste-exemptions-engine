# frozen_string_literal: true

module WasteExemptionsEngine
  class BetaStartFormsController < FormsController
    def new
      return render(:unavailable, status: 503) unless private_beta_active?
      return render(:invalid_token, status: 401) unless participant_token_valid? || params[:token].present?

      @action = :start

      # continue already started registration if beta participant opens beta-start link again
      if participant.present? && participant.registration.present?
        params[:token] = participant.registration.token
        # button text should be "Continue" if first registration page is already filled
        @action = :continue if participant.registration.location.present?
      end

      super(BetaStartForm, "beta_start_form")
    end

    def create
      super(BetaStartForm, "beta_start_form")
    end

    private

    def private_beta_active?
      WasteExemptionsEngine::FeatureToggle.active?(:private_beta)
    end

    def participant
      WasteExemptionsEngine::BetaParticipant.find_by(token: params[:participant_token])
    end

    def participant_token_valid?
      return false if params[:participant_token].nil?

      participant.present? && participant&.registration_type != "WasteExemptionsEngine::Registration"
    end

    def transient_registration_attributes
      params.fetch(:beta_start_form, {}).permit(:beta_start_option)
    end

    def find_or_initialize_registration(token)
      @transient_registration = TransientRegistration.find_by(
        token: token
      ) || NewChargedRegistration.new

      participant.update(registration: @transient_registration) if participant.present?
    end
  end
end
