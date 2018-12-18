# frozen_string_literal: true

WasteExemptionsEngine::Engine.routes.draw do

  resources :start_forms,
            only: [:new, :create],
            path: "start",
            path_names: { new: "/:token" }

  resources :contact_agency_forms,
            only: [:new, :create],
            path: "contact-agency",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "contact_agency_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :location_forms,
            only: [:new, :create],
            path: "location",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "location_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :register_in_northern_ireland_forms,
            only: [:new, :create],
            path: "register-in-northern-ireland",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "register_in_northern_ireland_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :register_in_scotland_forms,
            only: [:new, :create],
            path: "register-in-scotland",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "register_in_scotland_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :register_in_wales_forms,
            only: [:new, :create],
            path: "register-in-wales",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "register_in_wales_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :applicant_name_forms,
            only: [:new, :create],
            path: "applicant-name",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "applicant_name_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :applicant_phone_forms,
            only: [:new, :create],
            path: "applicant-phone",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "applicant_phone_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :applicant_email_forms,
            only: [:new, :create],
            path: "applicant-email",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "applicant_email_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :business_type_forms,
            only: [:new, :create],
            path: "business-type",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "business_type_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :registration_number_forms,
            only: [:new, :create],
            path: "registration-number",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "registration_number_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :operator_name_forms,
            only: [:new, :create],
            path: "operator-name",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "operator_name_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :contact_name_forms,
            only: [:new, :create],
            path: "contact-name",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "contact_name_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :contact_position_forms,
            only: [:new, :create],
            path: "contact-position",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "contact_position_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :contact_phone_forms,
            only: [:new, :create],
            path: "contact-phone",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "contact_phone_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :contact_email_forms,
            only: [:new, :create],
            path: "contact-email",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "contact_email_forms#go_back",
              as: "back",
              on: :collection
            end

  resources :is_a_farm_forms,
            only: [:new, :create],
            path: "is-a-farm",
            path_names: { new: "/:token" } do
              get "back/:token",
              to: "is_a_farm_forms#go_back",
              as: "back",
              on: :collection
            end

  # See http://patrickperey.com/railscast-053-handling-exceptions/
  get "(errors)/:id", to: "errors#show", as: "error"

  # Static pages with HighVoltage
  resources :pages, only: [:show], controller: "pages"
end
