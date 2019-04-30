# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
WasteExemptionsEngine::Engine.routes.draw do

  resources :start_forms,
            only: %i[new create],
            path: "start",
            path_names: { new: "/:token" }

  resources :contact_agency_forms,
            only: %i[new create],
            path: "contact-agency",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "contact_agency_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :location_forms,
            only: %i[new create],
            path: "location",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "location_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :register_in_northern_ireland_forms,
            only: %i[new create],
            path: "register-in-northern-ireland",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "register_in_northern_ireland_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :register_in_scotland_forms,
            only: %i[new create],
            path: "register-in-scotland",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "register_in_scotland_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :register_in_wales_forms,
            only: %i[new create],
            path: "register-in-wales",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "register_in_wales_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :applicant_name_forms,
            only: %i[new create],
            path: "applicant-name",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "applicant_name_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :applicant_phone_forms,
            only: %i[new create],
            path: "applicant-phone",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "applicant_phone_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :applicant_email_forms,
            only: %i[new create],
            path: "applicant-email",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "applicant_email_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :business_type_forms,
            only: %i[new create],
            path: "business-type",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "business_type_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :registration_number_forms,
            only: %i[new create],
            path: "registration-number",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "registration_number_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :main_people_forms,
            only: %i[new create],
            path: "main-people",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "main_people_forms#go_back",
                  as: "back",
                  on: :collection

              delete "delete_person/:id",
                     to: "main_people_forms#delete_person",
                     as: "delete_person",
                     on: :collection
            end

  resources :operator_name_forms,
            only: %i[new create],
            path: "operator-name",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "operator_name_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :operator_postcode_forms,
            only: %i[new create],
            path: "operator-postcode",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "operator_postcode_forms#go_back",
                  as: "back",
                  on: :collection

              get "skip_to_manual_address/:token",
                  to: "operator_postcode_forms#skip_to_manual_address",
                  as: "skip_to_manual_address",
                  on: :collection
            end

  resources :operator_address_lookup_forms,
            only: %i[new create],
            path: "operator-address-lookup",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "operator_address_lookup_forms#go_back",
                  as: "back",
                  on: :collection

              get "skip_to_manual_address/:token",
                  to: "operator_address_lookup_forms#skip_to_manual_address",
                  as: "skip_to_manual_address",
                  on: :collection
            end

  resources :operator_address_manual_forms,
            only: %i[new create],
            path: "operator-address-manual",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "operator_address_manual_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :contact_name_forms,
            only: %i[new create],
            path: "contact-name",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "contact_name_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :contact_position_forms,
            only: %i[new create],
            path: "contact-position",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "contact_position_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :contact_phone_forms,
            only: %i[new create],
            path: "contact-phone",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "contact_phone_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :contact_email_forms,
            only: %i[new create],
            path: "contact-email",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "contact_email_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :contact_postcode_forms,
            only: %i[new create],
            path: "contact-postcode",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "contact_postcode_forms#go_back",
                  as: "back",
                  on: :collection

              get "skip_to_manual_address/:token",
                  to: "contact_postcode_forms#skip_to_manual_address",
                  as: "skip_to_manual_address",
                  on: :collection
            end

  resources :contact_address_lookup_forms,
            only: %i[new create],
            path: "contact-address-lookup",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "contact_address_lookup_forms#go_back",
                  as: "back",
                  on: :collection

              get "skip_to_manual_address/:token",
                  to: "contact_address_lookup_forms#skip_to_manual_address",
                  as: "skip_to_manual_address",
                  on: :collection
            end

  resources :contact_address_manual_forms,
            only: %i[new create],
            path: "contact-address-manual",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "contact_address_manual_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :on_a_farm_forms,
            only: %i[new create],
            path: "on-a-farm",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "on_a_farm_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :is_a_farmer_forms,
            only: %i[new create],
            path: "is-a-farmer",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "is_a_farmer_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :site_grid_reference_forms,
            only: %i[new create],
            path: "site-grid-reference",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "site_grid_reference_forms#go_back",
                  as: "back",
                  on: :collection

              get "skip_to_address/:token",
                  to: "site_grid_reference_forms#skip_to_address",
                  as: "skip_to_address",
                  on: :collection
            end

  resources :site_postcode_forms,
            only: %i[new create],
            path: "site-postcode",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "site_postcode_forms#go_back",
                  as: "back",
                  on: :collection

              get "skip_to_manual_address/:token",
                  to: "site_postcode_forms#skip_to_manual_address",
                  as: "skip_to_manual_address",
                  on: :collection
            end

  resources :site_address_lookup_forms,
            only: %i[new create],
            path: "site-address-lookup",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "site_address_lookup_forms#go_back",
                  as: "back",
                  on: :collection

              get "skip_to_manual_address/:token",
                  to: "site_address_lookup_forms#skip_to_manual_address",
                  as: "skip_to_manual_address",
                  on: :collection
            end

  resources :site_address_manual_forms,
            only: %i[new create],
            path: "site-address-manual",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "site_address_manual_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :exemptions_forms,
            only: %i[new create],
            path: "exemptions",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "exemptions_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :check_your_answers_forms,
            only: %i[new create],
            path: "check-your-answers",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "check_your_answers_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :declaration_forms,
            only: %i[new create],
            path: "declaration",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "declaration_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :registration_complete_forms,
            only: %i[new create],
            path: "registration-complete",
            path_names: { new: "/:token" }

  # Editing
  resources :edit_forms,
            only: %i[new create],
            path: "edit",
            path_names: { new: "/:token" } do
              get "location/:token",
                  to: "edit_forms#edit_location",
                  as: "location",
                  on: :collection

              get "applicant_name/:token",
                  to: "edit_forms#edit_applicant_name",
                  as: "applicant_name",
                  on: :collection

              get "applicant_phone/:token",
                  to: "edit_forms#edit_applicant_phone",
                  as: "applicant_phone",
                  on: :collection

              get "applicant_email/:token",
                  to: "edit_forms#edit_applicant_email",
                  as: "applicant_email",
                  on: :collection

              get "main_people/:token",
                  to: "edit_forms#edit_main_people",
                  as: "main_people",
                  on: :collection

              get "registration_number/:token",
                  to: "edit_forms#edit_registration_number",
                  as: "registration_number",
                  on: :collection

              get "operator_name/:token",
                  to: "edit_forms#edit_operator_name",
                  as: "operator_name",
                  on: :collection

              get "operator_postcode/:token",
                  to: "edit_forms#edit_operator_postcode",
                  as: "operator_postcode",
                  on: :collection

              get "contact_name/:token",
                  to: "edit_forms#edit_contact_name",
                  as: "contact_name",
                  on: :collection

              get "contact_phone/:token",
                  to: "edit_forms#edit_contact_phone",
                  as: "contact_phone",
                  on: :collection

              get "contact_email/:token",
                  to: "edit_forms#edit_contact_email",
                  as: "contact_email",
                  on: :collection

              get "contact_postcode/:token",
                  to: "edit_forms#edit_contact_postcode",
                  as: "contact_postcode",
                  on: :collection

              get "on_a_farm/:token",
                  to: "edit_forms#edit_on_a_farm",
                  as: "on_a_farm",
                  on: :collection

              get "is_a_farmer/:token",
                  to: "edit_forms#edit_is_a_farmer",
                  as: "is_a_farmer",
                  on: :collection

              get "site_grid_reference/:token",
                  to: "edit_forms#edit_site_grid_reference",
                  as: "site_grid_reference",
                  on: :collection

              get "cancel/:token",
                  to: "edit_forms#cancel",
                  as: "cancel",
                  on: :collection
            end

  resources :edit_complete_forms,
            only: %i[new create],
            path: "edit-complete",
            path_names: { new: "/:token" }

  resources :confirm_edit_cancelled_forms,
            only: %i[new create],
            path: "confirm-edit-cancelled",
            path_names: { new: "/:token" } do
              get "back/:token",
                  to: "confirm_edit_cancelled_forms#go_back",
                  as: "back",
                  on: :collection
            end

  resources :edit_cancelled_forms,
            only: %i[new create],
            path: "edit-cancelled",
            path_names: { new: "/:token" }

  # Expose the data stored by the LastEmailCacheService
  get "/last-email",
      to: "last_email#show",
      as: "last_email",
      constraints: ->(_request) { WasteExemptionsEngine.configuration.use_last_email_cache }

  # See http://patrickperey.com/railscast-053-handling-exceptions/
  get "errors/:id", to: "errors#show", as: "error"

  # Static pages with HighVoltage
  resources :pages, only: [:show], controller: "pages"
end
# rubocop:enable Metrics/BlockLength
