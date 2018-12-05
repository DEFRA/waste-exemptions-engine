# frozen_string_literal: true

WasteExemptionsEngine::Engine.routes.draw do
  # Static pages with HighVoltage
  resources :pages, only: [:show], controller: "pages"
end
