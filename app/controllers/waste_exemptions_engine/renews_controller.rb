# frozen_string_literal: true

# Temporary controller for testing RUBY-491
module WasteExemptionsEngine
  class RenewsController < ApplicationController
    def new
      @renewal = RenewalStartService.run
    end
  end
end
