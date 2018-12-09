# frozen_string_literal: true

WasteExemptionsEngine::Engine.routes.draw do

  resources :start_forms,
            only: [:new, :create],
            path: "start",
            path_names: { new: "/:id" }

  # See http://patrickperey.com/railscast-053-handling-exceptions/
  get "(errors)/:id", to: "errors#show", as: "error"

  # Static pages with HighVoltage
  resources :pages, only: [:show], controller: "pages"
end
