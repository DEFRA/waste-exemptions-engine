# frozen_string_literal: true

module WasteExemptionsEngine
  class LastEmailController < ApplicationController
    def show
      render json: WasteExemptionsEngine::LastEmailCacheService.instance.last_email_json
    end
  end
end
