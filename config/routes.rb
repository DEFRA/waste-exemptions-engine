# frozen_string_literal: true

WasteExemptionsEngine::Engine.routes.draw do

  resources :start_forms,
            only: [:new, :create],
            path: "start",
            path_names: { new: "/:id" }

  resources :location_forms,
            only: [:new, :create],
            path: "location",
            path_names: { new: "/:id" } do
              get "back/:id",
              to: "location_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :register_in_northern_ireland_forms,
            only: [:new, :create],
            path: "register-in-northern-ireland",
            path_names: { new: "/:id" } do
              get "back/:id",
              to: "register_in_northern_ireland_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :register_in_scotland_forms,
            only: [:new, :create],
            path: "register-in-scotland",
            path_names: { new: "/:id" } do
              get "back/:id",
              to: "register_in_scotland_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :register_in_wales_forms,
            only: [:new, :create],
            path: "register-in-wales",
            path_names: { new: "/:id" } do
              get "back/:id",
              to: "register_in_wales_forms#go_back",
              as: "back",
              on: :collection
            end

  # See http://patrickperey.com/railscast-053-handling-exceptions/
  get "(errors)/:id", to: "errors#show", as: "error"

  # Static pages with HighVoltage
  resources :pages, only: [:show], controller: "pages"
end
