# frozen_string_literal: true

module WasteExemptionsEngine
  class BetaParticipantsController < ::ApplicationController
    before_action :check_private_beta_active, except: %i[unavailable invalid_token]
    before_action :check_participant_token_valid, except: %i[unavailable invalid_token]

    def opt_in
      participant.update(opted_in: true)
      redirect_to opt_in_confirmation_beta_participants_path
    end

    def opt_out
      participant.update(opted_in: false)
      redirect_to opt_out_confirmation_beta_participants_path
    end

    def opt_in_confirmation
      # view only
    end

    def opt_out_confirmation
      # view only
    end

    def opt_error
      # view only
    end

    private

    def check_private_beta_active
      return if private_beta_active?

      redirect_to private_beta_unavailable_path
    end

    def check_participant_token_valid
      return if participant_token_valid? || params[:token].present?

      redirect_to private_beta_invalid_token_path
    end

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
  end
end
