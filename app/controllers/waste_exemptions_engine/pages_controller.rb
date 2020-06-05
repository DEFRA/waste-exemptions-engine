# frozen_string_literal: true

module WasteExemptionsEngine
  class PagesController < ::WasteExemptionsEngine::ApplicationController
    include HighVoltage::StaticPage
  end
end
