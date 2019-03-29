# frozen_string_literal: true

module WasteExemptionsEngine
  class LastEmailController < ApplicationController
    def show
      if ENV["ENABLE_LAST_EMAIL_CACHE"] == "true"
        render json: WasteExemptionsEngine::LastEmailCacheService.instance.last_email_json
      else
        handle_disabled
      end
    end

    private

    def handle_disabled
      redirect_to error_path(404), status: 404
    end
  end
end
